import json
import os
import shutil
import socket
import subprocess
import threading
import time
from dataclasses import dataclass
from queue import Queue, Empty

from config import AppConfig


_JAVA_EXECUTABLE = shutil.which("java") or "java"
if not shutil.which(_JAVA_EXECUTABLE):
    java_home = os.environ.get("JAVA_HOME")
    if java_home:
        candidate = os.path.join(java_home, "bin", "java")
        if os.path.exists(candidate):
            _JAVA_EXECUTABLE = candidate


@dataclass
class JARInstance:
    port: int
    config_dir: str
    process: subprocess.Popen
    in_use: bool = False


class JarPool:
    def __init__(self, config: AppConfig, max_instances: int | None = None):
        self._config = config
        self._dbms = config.dbms
        self._max_instances = max_instances or config.jar_pool.max_instances

        self._template_dir = os.path.normpath(os.path.join(
            os.path.dirname(os.path.abspath(__file__)),
            "..", "configs", "sqlcraft", config.dbms
        ))

        if not os.path.exists(self._template_dir):
            raise FileNotFoundError(
                f"SQLCraft config template not found: {self._template_dir}"
            )

        self._instances_root = os.path.abspath(os.path.normpath(
            config.jar_instances_dir or
            os.path.join(config.work_dir, ".jar_instances")
        ))

        self._instances: list[JARInstance] = []
        self._queue: Queue = Queue()
        self._lock = threading.Lock()

        self._init_instances()

    def _init_instances(self):
        os.makedirs(self._instances_root, exist_ok=True)

        for i in range(self._max_instances):
            port = self._config.jar_pool.base_port + i
            instance_dir = os.path.abspath(os.path.join(
                self._instances_root, f"instance_{i}"
            ))

            if os.path.exists(instance_dir):
                shutil.rmtree(instance_dir, ignore_errors=True)
            shutil.copytree(self._template_dir, instance_dir, dirs_exist_ok=True)

            config_path = os.path.join(instance_dir, "configs.json")
            with open(config_path, "r", encoding="utf-8") as f:
                inst_config = json.load(f)

            key_defaults = {
                "typesJsonPath": "datatypes/types.json",
                "grammarPath": "grammars/grammar.g4",
                "recordRulePath": "grammars/recordRules.log",
            }
            for key in ("typesJsonPath", "grammarPath", "recordRulePath"):
                if key in inst_config:
                    inst_config[key] = os.path.normpath(
                        os.path.join(instance_dir, key_defaults.get(key, os.path.basename(inst_config[key])))
                    )
            if "typesDir" in inst_config:
                inst_config["typesDir"] = os.path.normpath(
                    os.path.join(instance_dir, "datatypes")
                )

            with open(config_path, "w", encoding="utf-8") as f:
                json.dump(inst_config, f, indent=2)

            jar_path = self._config.jar_pool.jar_path
            if not os.path.isabs(jar_path):
                candidate = os.path.normpath(
                    os.path.join(self._template_dir, "..", "..", "..", jar_path)
                )
                if not os.path.exists(candidate):
                    candidate = os.path.normpath(
                        os.path.join(self._instances_root, "..", jar_path)
                    )
                jar_path = candidate

                process = subprocess.Popen(
                    [_JAVA_EXECUTABLE, "-jar", jar_path, "configs.json", "10", "0", str(port)],
                    cwd=instance_dir,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )

            instance = JARInstance(
                port=port,
                config_dir=instance_dir,
                process=process,
            )
            self._instances.append(instance)
            self._queue.put(instance)

        self._wait_ready()

    def _wait_ready(self, timeout: float = 30.0):
        deadline = time.time() + timeout
        for instance in self._instances:
            while time.time() < deadline:
                if self._verify_jar(instance.port):
                    break
                time.sleep(0.5)
            else:
                raise RuntimeError(
                    f"JAR instance on port {instance.port} failed to start "
                    f"within {timeout}s"
                )

    @staticmethod
    def _check_port(port: int) -> bool:
        try:
            s = socket.create_connection(("127.0.0.1", port), timeout=2)
            s.close()
            return True
        except (ConnectionRefusedError, OSError):
            return False

    @staticmethod
    def _verify_jar(port: int, timeout: float = 5.0) -> bool:
        try:
            s = socket.create_connection(("127.0.0.1", port), timeout=timeout)
            s.settimeout(timeout)
            try:
                s.recv(1)
            except socket.timeout:
                pass
            s.close()
            return True
        except (ConnectionRefusedError, OSError, socket.timeout, ConnectionResetError):
            return False

    def acquire(self, timeout: float | None = None) -> JARInstance:
        try:
            instance = self._queue.get(timeout=timeout)
        except Empty:
            raise RuntimeError(
                f"No JAR instance available within {timeout}s"
            )

        with self._lock:
            instance.in_use = True

        if not self._verify_jar(instance.port):
            self._restart(instance)

        return instance

    def release(self, instance: JARInstance):
        with self._lock:
            instance.in_use = False
        self._queue.put(instance)

    def _restart(self, instance: JARInstance):
        from utils.log import log

        try:
            instance.process.kill()
            instance.process.wait(timeout=5)
        except Exception:
            pass

        time.sleep(1)

        jar_path = self._config.jar_pool.jar_path
        if not os.path.isabs(jar_path):
            candidate = os.path.normpath(
                os.path.join(self._template_dir, "..", "..", "..", jar_path)
            )
            if not os.path.exists(candidate):
                candidate = os.path.normpath(
                    os.path.join(self._instances_root, "..", jar_path)
                )
            jar_path = candidate

        for attempt in range(3):
            instance.process = subprocess.Popen(
                [_JAVA_EXECUTABLE, "-jar", jar_path, "configs.json", "10", "0",
                 str(instance.port)],
                cwd=instance.config_dir,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )

            deadline = time.time() + 30
            healthy = False
            while time.time() < deadline:
                if self._verify_jar(instance.port):
                    healthy = True
                    break
                time.sleep(1)

            if healthy:
                return

            log.warn(f"  JAR {instance.port} attempt {attempt+1} restart failed health check, retrying...")
            try:
                instance.process.kill()
                instance.process.wait(timeout=3)
            except Exception:
                pass
            time.sleep(2)

        raise RuntimeError(
            f"Failed to restart JAR instance on port {instance.port} after 3 attempts"
        )

    def shutdown(self):
        for instance in self._instances:
            try:
                instance.process.kill()
                instance.process.wait(timeout=5)
            except Exception:
                pass

    @property
    def instance_count(self) -> int:
        return len(self._instances)

    @property
    def available_count(self) -> int:
        return self._queue.qsize()

    def __len__(self) -> int:
        return self.available_count

    def __enter__(self):
        return self

    def __exit__(self, *args):
        self.shutdown()

