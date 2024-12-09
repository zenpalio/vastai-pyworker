import json
import os
import logging
from typing import List
import ssl
from asyncio import run, gather
from urllib.parse import urljoin

import requests


from lib.backend import Backend
from aiohttp import web

from lib.metrics import get_container_id, get_provider, get_url

log = logging.getLogger(__file__)


def register_public_ip():
    report_addr = os.environ["REPORT_ADDR"]
    for addr in report_addr.split(","):
        full_path = urljoin(addr, "/public/v1/webhook/instance/register/")
        data = {
            "url": get_url(),
            "id": get_container_id(),
            "type": os.environ["BACKEND"],
            "provider": get_provider(),
        }
        log.debug("register payload")
        print(data)
        try:
            requests.post(full_path, json=data, timeout=1)
        except Exception as e:
            log.debug(f"autoscaler status update failed with error: {e}")


def start_server(backend: Backend, routes: List[web.RouteDef], **kwargs):
    log.debug("getting certificate...")
    use_ssl = os.environ.get("USE_SSL", "false") == "true"
    if use_ssl is True:
        ssl_context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
        ssl_context.load_cert_chain(
            certfile="/etc/instance.crt",
            keyfile="/etc/instance.key",
        )
    else:
        ssl_context = None

    async def main():
        log.debug("starting server...")
        app = web.Application()
        app.add_routes(routes)
        runner = web.AppRunner(app)
        await runner.setup()
        site = web.TCPSite(
            runner,
            ssl_context=ssl_context,
            port=int(os.environ["WORKER_PORT"]),
            **kwargs,
        )
        register_public_ip()
        await gather(site.start(), backend._start_tracking())

    run(main())
