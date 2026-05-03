import atexit
import json
import logging
import os.path
import re
import signal
import socket
import subprocess
import sys
import time
from collections import defaultdict

from custom_error import SQLCraftJarError

SQLCRAFT_JAR_PATH = r"./jar/SQLCraft-1.0.jar"
HOST = "127.0.0.1"
PORT = 5678
# PORT = 5679
SUCCESS_FLAG = f"Socket daemon started, listening on port: {PORT}"
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
                    return _line

                sock.sendall(f"{command}\n".encode("utf-8"))
                while True:
                    line = recv_line()
                    if line is None:
                        raise RuntimeError("Server closed")
                    if line.rstrip("\r\n") == "END":
                        break
                    if line.startswith("ERROR: "):
                        raise Exception(line[7:])
                    if line == "yes":
                        # result.append(f"{last_sql};")
                        continue
                    else:
                        sql = str(line).replace("\r", "")
                        result.append(f"{sql};")

                sock.sendall("exit\n".encode("utf-8"))
                exit_flag = recv_line()
                if exit_flag != EXIT_FLAG:
                    raise RuntimeError("Server did not exit")

        except Exception as e:
            if "Server closed" in str(e):
                raise Exception(f"Error occurred while connecting to the SQL generator: {str(e)}. This error may be caused by invalid rules, such as missing double quotes around literals. Without the quotes, literals are incorrectly recognized as non-terminal symbols, which lack corresponding production rules, leading to rule invalidity and causing the process to terminate immediately.")
            raise Exception(f"Error occurs when connecting to sql generator: {str(e)}")
        return result


if __name__ == '__main__':
    sql_generator = SQLGenerator(r"./jar/configs/postgres/normal_configs_pve.json")
    sql_generator.run_sqlcraft()
    result = sql_generator.call_sqlcraft("learnR: query 0 100")
    for line in result:
        print(line)