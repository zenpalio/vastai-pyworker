import json
import os
import logging
import re
from typing import Literal, Union, Type
import dataclasses

from aiohttp import web, ClientResponse
import requests

from lib.backend import Backend, LogAction
from lib.data_types import EndpointHandler
from lib.metrics import get_url
from lib.server import start_server
from .data_types import InputData


MODEL_SERVER_URL = "http://127.0.0.1:7860"

# This is the last log line that gets emitted once comfyui+extensions have been fully loaded
MODEL_SERVER_START_LOG_MSG = '"message":"Connected","target":"text_generation_router"'
MODEL_SERVER_ERROR_LOG_MSGS = ["Error: WebserverFailed", "Error: DownloadError"]


logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s[%(levelname)-5s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
log = logging.getLogger(__file__)

URL = "http://127.0.0.1:7860"


@dataclasses.dataclass
class GenerateHandler(EndpointHandler[InputData]):
    method: Literal["sdapi/v1/txt2img", "/sdapi/v1/options"] = "sdapi/v1/txt2img"

    @property
    def endpoint(self) -> str:
        return f"http://127.0.0.1:7860/{self.method}"

    @classmethod
    def payload_cls(cls) -> Type[InputData]:
        return InputData

    def make_benchmark_payload(self) -> InputData:
        return InputData.for_test()

    async def generate_client_response(
        self, client_request: web.Request, model_response: ClientResponse
    ) -> Union[web.Response, web.StreamResponse]:
        _ = client_request
        log.debug(model_response)
        match model_response.status:
            case 200:
                log.debug("SUCCESS")
                data = await model_response.json()
                return web.json_response(data=data)
            case code:
                log.debug("SENDING RESPONSE: ERROR: unknown code")

                return web.Response(status=code)


backend = Backend(
    model_server_url=MODEL_SERVER_URL,
    model_log_file=os.environ["MODEL_LOG"],
    allow_parallel_requests=True,
    benchmark_handler=GenerateHandler(benchmark_runs=3, benchmark_words=256),
    log_actions=[
        (LogAction.ModelLoaded, MODEL_SERVER_START_LOG_MSG),
        (LogAction.Info, '"message":"Download'),
        *[
            (LogAction.ModelError, error_msg)
            for error_msg in MODEL_SERVER_ERROR_LOG_MSGS
        ],
    ],
)


async def handle_ping(_):
    return web.Response(body="pong")


async def get_public_url(_):
    return web.Response(body=get_url())


async def update_model(request: web.Request):
    data = await request.json()
    if "model" not in data:
        return web.Response(body="Model missing in body", status=422)
    model = data["model"]

    opt_json = get_options()
    opt_json["sd_model_checkpoint"] = model
    requests.post(
        url=f"{URL}/sdapi/v1/options",
        json=opt_json,
        verify=False,  # Disable SSL verification
    )
    requests.post(
        url=f"{URL}/sdapi/v1/reload-checkpoint",
        verify=False,  # Disable SSL verification
    )
    return web.Response(body="Model updated to " + model)


async def get_active_model(_):
    opt_json = get_options()
    model_name = opt_json["sd_model_checkpoint"]
    return web.json_response(data={"model": model_name})


def get_options():
    requests.post(
        url=f"{URL}/sdapi/v1/refresh-checkpoints",
        verify=False,  # Disable SSL verification
    )
    opt = requests.get(
        url=f"{URL}/sdapi/v1/options",
        verify=False,  # Disable SSL verification
    )
    opt_json = opt.json()
    return opt_json


routes = [
    web.post("/txt2img", backend.create_handler(GenerateHandler("sdapi/v1/txt2img"))),
    web.post("/options", get_active_model),
    web.get("/ping", handle_ping),
    web.get("/public_url", get_public_url),
    web.get("/healthz", handle_ping),
    web.post("/model", update_model),
]

if __name__ == "__main__":
    start_server(backend, routes)
