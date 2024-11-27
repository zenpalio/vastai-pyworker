import asyncio
import os
import json
import time
import base64
import subprocess
import dataclasses
import logging
from asyncio import sleep, gather, Semaphore
from typing import Tuple, Awaitable, NoReturn, List, Union, Callable
from functools import cached_property

from anyio import open_file
from aiohttp import web, ClientResponse, ClientSession, ClientConnectorError

import requests
from Crypto.Signature import pkcs1_15
from Crypto.Hash import SHA256
from Crypto.PublicKey import RSA

from lib.metrics import Metrics, get_type
from lib.data_types import (
    AuthData,
    EndpointHandler,
    LogAction,
    ApiPayload_T,
    JsonDataException,
)

MSG_HISTORY_LEN = 100
log = logging.getLogger(__file__)

# defines the minimum wait time between sending updates to autoscaler
LOG_POLL_INTERVAL = 0.1
BENCHMARK_INDICATOR_FILE = ".has_benchmark"


@dataclasses.dataclass
class Backend:
    """
    This class is responsible for:
    1. Tailing logs and updating load time metrics
    2. Taking an EndpointHandler alongside incoming payload, preparing a json to be sent to the model, and
    sending the request. It also updates metrics as it makes those requests.
    3. Running a benchmark from an EndpointHandler
    """

    model_server_url: str
    model_log_file: str
    allow_parallel_requests: bool
    benchmark_handler: (
        EndpointHandler  # this endpoint handler will be used for benchmarking
    )
    log_actions: List[Tuple[LogAction, str]]
    reqnum = -1
    msg_history = []
    sem: Semaphore = dataclasses.field(default_factory=Semaphore)

    def __post_init__(self):

        def fetch_public_key():
            command = ["curl", "-X", "GET", "https://run.vast.ai/pubkey/"]
            result = subprocess.check_output(command, universal_newlines=True)
            log.debug("public key:")
            log.debug(result)
            key = None
            for _ in range(2):
                try:
                    key = RSA.import_key(result)
                    break
                except ValueError as e:
                    log.debug(f"Error downloading key: {e}")
                    time.sleep(2)
            return key

        ###########

        self.PUBLIC_KEY = fetch_public_key()
        self.metrics = Metrics()

    @cached_property
    def session(self):
        log.debug(f"starting new session with {self.model_server_url}")
        return ClientSession(self.model_server_url)

    def create_handler(
        self,
        handler: EndpointHandler[dict],
    ) -> Callable[[web.Request], Awaitable[Union[web.Response, web.StreamResponse]]]:
        async def handler_fn(
            request: web.Request,
        ) -> Union[web.Response, web.StreamResponse]:
            return await self.__handle_request(handler=handler, request=request)

        return handler_fn

    #######################################Private#######################################
    async def __handle_request(
        self,
        handler: EndpointHandler[ApiPayload_T],
        request: web.Request,
    ) -> Union[web.Response, web.StreamResponse]:
        """use this function to forward requests to the model endpoint"""
        try:

            data = await request.json()
        except JsonDataException as e:
            return web.json_response(data=e.message, status=422)
        except json.JSONDecodeError:
            return web.json_response(dict(error="invalid JSON"), status=422)

        def post(url: str, dct: dict = None):
            log.debug(f"url: {url}")
            log.debug(dct)
            # TODO: blocking call to async
            resp = requests.post(url, data=dct, timeout=300, verify=False)
            print(resp.status_code)
            if resp.status_code != 200:
                return {
                    "error": resp.status_code,
                    "reason": resp.reason,
                    "url": resp.url,
                }
            else:
                return resp.json()

        try:

            response = await asyncio.to_thread(post, handler.endpoint, data)
            return web.json_response(response)
        except Exception as e:
            log.debug(f"Exception in main handler loop {e}")
            log.debug(e.message)
            return web.Response(status=500)

    async def _start_tracking(self) -> None:
        await gather(self.__read_logs(), self.metrics._send_metrics_loop())

    def backend_errored(self, msg: str) -> None:
        self.metrics._model_errored(msg)

    async def __call_api(
        self, handler: EndpointHandler[ApiPayload_T], payload: ApiPayload_T
    ) -> ClientResponse:
        api_payload = payload.generate_payload_json()
        log.debug(f"posting to endpoint: '{handler.endpoint}', payload: {api_payload}")
        timeout = 600
        if get_type() == "tgi":
            timeout = 30
        return await self.session.post(
            url=handler.endpoint,
            data=api_payload,
            headers={"Content-Type": "application/json"},
            timeout=timeout,
        )

    def __check_signature(self, auth_data: AuthData) -> bool:
        def verify_signature(message, signature):
            if self.PUBLIC_KEY is None:
                log.debug(f"No Public Key!")
                return False

            h = SHA256.new(message.encode())
            try:
                pkcs1_15.new(self.PUBLIC_KEY).verify(h, base64.b64decode(signature))
                return True
            except (ValueError, TypeError):
                return False

        message = {
            key: value
            for (key, value) in (dataclasses.asdict(auth_data).items())
            if key != "signature"
        }
        if auth_data.reqnum < (self.reqnum - MSG_HISTORY_LEN):
            log.debug(
                f"reqnum failure, got {auth_data.reqnum}, current_reqnum: {self.reqnum}"
            )
            return False
        elif message in self.msg_history:
            log.debug(f"message: {message} already in message history")
            return False
        elif verify_signature(json.dumps(message, indent=4), auth_data.signature):
            self.reqnum = max(auth_data.reqnum, self.reqnum)
            self.msg_history.append(message)
            self.msg_history = self.msg_history[-MSG_HISTORY_LEN:]
            return True
        else:
            log.debug(
                f"signature verification failed, sig:{auth_data.signature}, message: {message}"
            )
            return False

    async def __read_logs(self) -> Awaitable[NoReturn]:

        async def run_benchmark() -> float:
            log.debug("starting benchmark")
            try:
                with open(BENCHMARK_INDICATOR_FILE, "r") as f:
                    log.debug("already ran benchmark")
                    # trigger model load
                    payload = self.benchmark_handler.make_benchmark_payload()
                    _ = await self.__call_api(
                        handler=self.benchmark_handler, payload=payload
                    )
                    return float(f.readline())
            except FileNotFoundError:
                pass
            max_throughput = 0
            last_throughput = 0
            sum_throughput = 0
            for run in range(self.benchmark_handler.benchmark_runs + 1):
                start = time.time()
                payload = self.benchmark_handler.make_benchmark_payload()
                res = await self.__call_api(
                    handler=self.benchmark_handler, payload=payload
                )
                data = await res.json()
                time_elapsed = time.time() - start
                # first run triggers one-time loading of the model which is very slow, so we skip counting it
                if run == 0:
                    continue
                else:
                    workload = payload.count_workload()
                    last_throughput = workload / time_elapsed
                    sum_throughput += last_throughput
                    max_throughput = max(max_throughput, last_throughput)
                    log.debug(
                        "\n".join(
                            [
                                "#" * 60,
                                f"Run: {run}, workload: {workload} time_elapsed: {time_elapsed}, throughput: {last_throughput}",
                                "",
                                f"response: {data}",
                                "#" * 60,
                            ]
                        )
                    )
            average_throughput = sum_throughput / self.benchmark_handler.benchmark_runs
            log.debug(
                f"benchmark result: avg {average_throughput} workload per second, max {max_throughput}"
            )
            # save max_throughput so we don't have to run benchmark again on restart of cold instances
            with open(BENCHMARK_INDICATOR_FILE, "w") as f:
                f.write(str(max_throughput))
            return max_throughput

        async def handle_log_line(log_line: str) -> None:
            """
            Implement this function to handle each log line for your model.
            This function should mutate self.system_metrics and self.model_metrics
            """
            for action, msg in self.log_actions:
                match action:
                    case LogAction.ModelLoaded if msg in log_line:
                        log.debug(
                            f"Got log line indicating model is loaded: {log_line}"
                        )
                        # some backends need a few seconds after logging successful startup before
                        # they can begin accepting requests
                        await sleep(5)
                        try:
                            max_throughput = await run_benchmark()
                            self.metrics._model_loaded(
                                max_throughput=max_throughput,
                            )
                        except ClientConnectorError as e:
                            log.debug(
                                f"failed to connect to comfyui api during benchmark"
                            )
                            self.backend_errored(str(e))
                    case LogAction.ModelError if msg in log_line:
                        log.debug(f"Got log line indicating error: {log_line}")
                        self.backend_errored(msg)
                        break
                    case LogAction.Info if msg in log_line:
                        log.debug(f"Info from model logs: {log_line}")

        async def tail_log():
            log.debug(f"tailing file: {self.model_log_file}")
            async with await open_file(self.model_log_file) as f:
                while True:
                    line = await f.readline()
                    if line:
                        await handle_log_line(line.rstrip())
                    else:
                        time.sleep(LOG_POLL_INTERVAL)

        ###########

        while True:
            if os.path.isfile(self.model_log_file) is True:
                return await tail_log()
            else:
                await sleep(1)
