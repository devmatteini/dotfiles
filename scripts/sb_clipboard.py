"""Serve clipboard images to a sandboxed agent.

Runs on the host and reads input controlled by the agent: keep it minimal and
stdlib only. Started by sb_lib.start_clipboard_helper.

Usage: sb_clipboard.py LISTEN_FD WATCHED_PID HARNESS XCLIP

Protocol, one request per connection:
- request: `TARGETS\\n` or `image/png\\n`
- response: 1 status byte, then the payload until EOF
"""

import logging
import os
import select
import socket
import subprocess
import sys
import threading
from contextlib import suppress
from logging.handlers import RotatingFileHandler
from pathlib import Path

IMAGE_TARGETS = frozenset(
    f"image/{kind}".encode() for kind in ("png", "jpeg", "jpg", "gif", "webp", "bmp")
)
STATUS_OK = b"\x00"
STATUS_ERROR = b"\x01"
MAX_REQUEST_BYTES = 64
MAX_OUTPUT_BYTES = 64 * 1024 * 1024
TIMEOUT_SECONDS = 5
# Outside the grants of the agent profiles, so the agent cannot alter it
LOG_PATH = ".local/state/sb/clipboard.log"
LOG_MAX_BYTES = 1024 * 1024


def read_clipboard(xclip: str, target: str) -> bytes | None:
    with subprocess.Popen(
        [xclip, "-selection", "clipboard", "-t", target, "-o"],
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
    ) as process:
        assert process.stdout is not None
        timer = threading.Timer(TIMEOUT_SECONDS, process.kill)
        timer.start()
        try:
            output = process.stdout.read(MAX_OUTPUT_BYTES + 1)
            if len(output) > MAX_OUTPUT_BYTES:
                return None
            return output if process.wait() == 0 else None
        finally:
            timer.cancel()
            process.kill()


def read_payload(request: bytes, xclip: str) -> bytes | None:
    # No parsing: anything but an exact match with the allowlist is rejected
    if request in IMAGE_TARGETS:
        return read_clipboard(xclip, request.decode())
    if request != b"TARGETS":
        return None
    targets = read_clipboard(xclip, "TARGETS")
    if targets is None:
        return None
    return b"".join(
        line + b"\n" for line in targets.splitlines() if line in IMAGE_TARGETS
    )


def serve_connection(connection: socket.socket, xclip: str) -> None:
    connection.settimeout(TIMEOUT_SECONDS)
    request = connection.recv(MAX_REQUEST_BYTES).removesuffix(b"\n")
    payload = read_payload(request, xclip)
    # repr: the request is controlled by the agent, it must stay on one line
    logging.info(
        "request=%r result=%s bytes=%d",
        request,
        "error" if payload is None else "ok",
        len(payload or b""),
    )
    connection.sendall(STATUS_ERROR if payload is None else STATUS_OK + payload)


def serve(listener: socket.socket, watched_pid: int, xclip: str) -> None:
    # The PID survives exec, so this ends together with bwrap
    pidfd = os.pidfd_open(watched_pid)
    while True:
        ready, _, _ = select.select([listener, pidfd], [], [])
        if pidfd in ready:
            return
        connection, _ = listener.accept()
        with connection, suppress(OSError):
            serve_connection(connection, xclip)


def configure_log(harness: str, watched_pid: str) -> None:
    path = Path.home() / LOG_PATH
    try:
        path.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
        handler = RotatingFileHandler(path, maxBytes=LOG_MAX_BYTES, backupCount=1)
    except OSError:
        return
    logging.basicConfig(
        handlers=[handler],
        level=logging.INFO,
        format=f"%(asctime)s harness={harness} sb_pid={watched_pid} %(message)s",
    )


def main() -> None:
    _, listen_fd, watched_pid, harness, xclip = sys.argv
    with socket.socket(fileno=int(listen_fd)) as listener:
        socket_path = Path(listener.getsockname())
        try:
            configure_log(harness, watched_pid)
            serve(listener, int(watched_pid), xclip)
        finally:
            socket_path.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
