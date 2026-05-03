import logging
import os
import signal
import socket
import atexit
import subprocess
import sys
import time

from custom_error import SQLCraftJarError

SQLCRAFT_JAR_PATH = r"./jar/SQLCraft-1.0.jar"
HOST = "127.0.0.1"
PORT = 5678
# PORT = 5679
# PORT = 5680
SUCCESS_FLAG = f"Socket server start ：{PORT}"
EXIT_FLAG = "server exit"


class SQLGenerator:
    def __init__(self, config_path):
        self.config_path = config_path
        self.proc = None
        self.started = False
        atexit.register(self.stop_sqlcraft)
        for sig in (signal.SIGINT, signal.SIGTERM, signal.SIGHUP):
            signal.signal(sig, lambda s, f: (self.stop_sqlcraft(), sys.exit(0)))

    def run_sqlcraft(self, timeout=10):
        logging.info("[MASTER] Starting SQLCraft.jar")
        self.proc = subprocess.Popen(
            ["java", "-jar", SQLCRAFT_JAR_PATH, self.config_path, "10", "0", str(PORT)],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            bufsize=1,
            start_new_session=True,
        )
        start_time = time.time()
        for line in iter(self.proc.stdout.readline, ""):
            line = line.strip()
            logging.info(f"[SQLCraft.jar] {line}")

            if SUCCESS_FLAG in line:
                self.started = True
                return

            if time.time() - start_time > timeout:
                break

        raise SQLCraftJarError("SQLCraft.jar did not start successfully")

    def stop_sqlcraft(self, timeout=10):
        try:
            if self.proc and self.proc.poll() is None:
                pgid = os.getpgid(self.proc.pid)
                logging.info(f"[MASTER] STOP SQLCraft.jar, pgid={pgid}")
                os.killpg(pgid, signal.SIGTERM)
                start = time.time()
                while time.time() - start < timeout:
                    if self.proc.poll() is not None:
                        return
                    time.sleep(0.2)
                logging.info("[MASTER] Force kill SQLCraft.jar")
                os.killpg(pgid, signal.SIGKILL)
        except Exception as e:
            raise SQLCraftJarError(f"Failed to stop SQLCraft.jar: {str(e)}")

    def call_sqlcraft(self, command):
        result = list()
        try:
            with socket.create_connection((HOST, PORT)) as sock:
                sock.settimeout(60 * 60)
                recv_buffer = ""

                def recv_line():
                    nonlocal recv_buffer
                    while "\n" not in recv_buffer:
                        data = sock.recv(4096)
                        if not data:
                            return None
                        recv_buffer += data.decode("utf-8")
                    _line, recv_buffer = recv_buffer.split("\n", 1)
                    return _line.rstrip("\r")

                sock.sendall((command + "\n").encode("utf-8"))
                while True:
                    line = recv_line()
                    if line is None:
                        raise RuntimeError("Server closed")
                    if line.rstrip("\r\n") == "END":
                        break
                    result.append(f"{line};")
                sock.sendall("exit\n".encode("utf-8"))
                exit_line = recv_line()
                if exit_line.rstrip("\r") != EXIT_FLAG.rstrip("\r"):
                    raise RuntimeError("Server did not exit")

        except Exception as e:
            self.started = False
            raise SQLCraftJarError(f"Error occurs when calling sqlcraft: {str(e)}")
        return result


if __name__ == "__main__":
    sql_generator = SQLGenerator("./jar/configs/mysql/radar_config.json")
    sql_generator.run_sqlcraft()
    for i in range(10):
        print(sql_generator.call_sqlcraft("test: a 0 1000"))
