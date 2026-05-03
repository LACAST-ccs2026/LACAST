import os
import sys
from datetime import datetime


class _Logger:
    def __init__(self):
        self._fh = None
        self._name = ""

    def init(self, filepath: str):
        if os.path.isdir(filepath) or filepath.endswith(os.sep) or filepath.endswith("/"):
            os.makedirs(filepath, exist_ok=True)
            ts = datetime.now().strftime("%Y%m%d_%H%M%S")
            filepath = os.path.join(filepath, f"run_{ts}.log")
        else:
            os.makedirs(os.path.dirname(filepath) or ".", exist_ok=True)
        self._fh = open(filepath, "a", encoding="utf-8")
        self._name = filepath
        self.info(f"Log file: {os.path.abspath(filepath)}")

    def _write(self, level: str, msg: str):
        ts = datetime.now().strftime("%H:%M:%S.%f")[:12]
        line = f"[{ts}][{level}] {msg}"
        try:
            print(line, flush=True)
        except UnicodeEncodeError:
            safe = line.encode("gbk", errors="replace").decode("gbk", errors="replace")
            safe = safe.replace("\ufffd", "?")
            print(safe, flush=True)
        if self._fh:
            self._fh.write(line + "\n")
            self._fh.flush()

    def info(self, msg: str):
        self._write("INFO", msg)

    def debug(self, msg: str):
        self._write("DEBG", msg)

    def warn(self, msg: str):
        self._write("WARN", msg)

    def error(self, msg: str):
        self._write("ERR", msg)

    def close(self):
        if self._fh:
            self._fh.close()

    @property
    def path(self) -> str:
        return self._name


log = _Logger()


def init_log(filepath: str):
    log.init(filepath)
