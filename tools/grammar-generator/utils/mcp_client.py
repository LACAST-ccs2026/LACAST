import json
import os
import re
import socket
from collections import defaultdict
from typing import Optional

from config import AppConfig
from utils.dbms_driver import DBMSDriver


class JARInstance:
    port: int

class SQLCraftError(Exception):
    pass


class SQLCraftSQLGenError(SQLCraftError):
    pass


class SQLCraftConnectedError(SQLCraftError):
    pass


class TestResult:
    __test__ = False

    def __init__(
        self,
        logs: list[str],
        accuracy: float,
        passed: bool,
        error_summary: Optional[str] = None,
        error_type: Optional[str] = None,
    ):
        self.logs = logs
        self.accuracy = accuracy
        self.passed = passed
        self.error_summary = error_summary
        self.error_type = error_type

    @classmethod
    def from_logs(cls, logs: list[str]) -> "TestResult":
        accuracy = 0.0
        passed = False
        error_summary = None
        error_type = None

        for line in logs:
            lower = line.lower()
            if line.startswith("Acc rate:"):
                accuracy = float(line.replace("Acc rate:", "").strip())
                passed = accuracy >= 0.95
            elif line.startswith("Error message:"):
                error_summary = line
                if "datatype" in lower or "unsupported" in lower:
                    error_type = "unsupported_datatype"
                elif "syntax" in lower:
                    error_type = "syntax_error"
                else:
                    error_type = error_type or "execution_error"
            elif "error" in lower:
                error_summary = error_summary or line

        return cls(
            logs=logs,
            accuracy=accuracy,
            passed=passed,
            error_summary=error_summary,
            error_type=error_type,
        )

class SQLGenerator:
    HOST = "127.0.0.1"
    EXIT_FLAG = "server exit\r"

    def __init__(self, config: AppConfig, sqlcraft_dir: str):
        self._config = config
        self._sqlcraft_dir = sqlcraft_dir

        config_path = os.path.join(sqlcraft_dir, "configs.json")
        with open(config_path, "r", encoding="utf-8") as f:
            self._cfg = json.load(f)

        types_path = os.path.join(sqlcraft_dir, self._cfg["typesJsonPath"])
        with open(types_path, "r", encoding="utf-8") as f:
            type_config = json.load(f)
        self.supported_datatypes: list[str] = type_config["types"]

        base_g4_path = os.path.join(sqlcraft_dir, "grammars", "base.g4")
        with open(base_g4_path, "r", encoding="utf-8") as f:
            self._base_g4 = f.read()

    @property
    def grammar_path(self) -> str:
        return os.path.join(self._sqlcraft_dir, self._cfg["grammarPath"])

    @property
    def record_rule_path(self) -> str:
        return os.path.join(self._sqlcraft_dir, self._cfg["recordRulePath"])

    def generate_grammar(
        self, trained_rules: dict, target_rule: dict, const_rule: dict
    ) -> int:
        productions: dict[str, list[str]] = defaultdict(list)

        for datatype in self.supported_datatypes:
            productions[f"{datatype}_evaluator"].append(
                f"{datatype}_evaluator_without_agg"
            )
            productions[f"{datatype}_evaluator_without_agg"].append(
                f"_var_{datatype}"
            )

        for rule in trained_rules.values():
            for type_eval, lefts in rule.get("eval2lefts", {}).items():
                productions[type_eval].extend(lefts)
                match = re.match(r"([a-zA-Z0-9_]+)_AGG_evaluator", type_eval)
                if match:
                    datatype = match.group(1)
                    if type_eval not in productions[f"{datatype}_evaluator"]:
                        productions[f"{datatype}_evaluator"].append(type_eval)
                        productions["agg_evaluator"].append(type_eval)
            _sanitized_l2r = {}
            for _left, _rights in rule.get("left2rights", {}).items():
                _sanitized_l2r[_left] = [r.replace('\\"', '"') for r in _rights]
            productions.update(_sanitized_l2r)
            productions.update(rule.get("const_prods", {}))

        type_eval = target_rule["type_eval"]
        left = target_rule["left"]
        right = target_rule["right"].replace('\\"', '"')

        match1 = re.match(
            r"([a-zA-Z0-9_]+)_evaluator_without_agg", type_eval
        )
        match2 = re.match(r"([a-zA-Z0-9_]+)_AGG_evaluator", type_eval)

        if match1:
            datatype = match1.group(1)
            if f"{datatype}_evaluator" not in productions:
                raise SQLCraftSQLGenError(
                    f"Unsupported datatype `{datatype}` in type_eval `{type_eval}`!"
                )
            productions[type_eval].append(left)
            productions[left].append(right)
        elif match2:
            datatype = match2.group(1)
            if f"{datatype}_evaluator" not in productions:
                raise SQLCraftSQLGenError(
                    f"Unsupported datatype `{datatype}` in type_eval `{type_eval}`!"
                )
            if type_eval not in productions[f"{datatype}_evaluator"]:
                productions[f"{datatype}_evaluator"].append(type_eval)
                productions["agg_evaluator"].append(type_eval)
            productions[type_eval].append(left)
            productions[left].append(right)
        else:
            raise SQLCraftSQLGenError(
                f"Invalid type_eval `{type_eval}` — must match "
                f"`<datatype>_evaluator_without_agg` or `<datatype>_AGG_evaluator`"
            )

        for const_left in const_rule:
            productions[const_left] = const_rule[const_left]

        grammar = f"{self._base_g4}\n\n"
        for _left, _rights in productions.items():
            grammar += f"{_left}: {'|'.join(_rights)};\n"

        os.makedirs(os.path.dirname(self.grammar_path), exist_ok=True)
        with open(self.grammar_path, "w", encoding="utf-8") as f:
            f.write(grammar)

        idx = len(productions[target_rule["left"]]) - 1
        os.makedirs(os.path.dirname(self.record_rule_path), exist_ok=True)
        with open(self.record_rule_path, "w", encoding="utf-8") as f:
            f.write(f"{target_rule['left']}: {idx}")

        return idx

    def generate_sqls(self, left: str, right_index: int, sql_nums: int,
                      port: int) -> list[str]:
        result: list[str] = []
        try:
            with socket.create_connection((self.HOST, port)) as sock:
                sock.settimeout(3600)
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

                while len(result) < sql_nums:
                    cmd = f"learnR: {left} {right_index} {sql_nums}\n"
                    sock.sendall(cmd.encode("utf-8"))
                    while True:
                        line = recv_line()
                        if line is None:
                            raise RuntimeError("Server closed")
                        if line == "END":
                            break
                        if line.startswith("ERROR: "):
                            raise SQLCraftSQLGenError(line[7:])
                        if line == "yes":
                            continue
                        else:
                            result.append(f"{line};")

                try:
                    sock.sendall("exit\n".encode("utf-8"))
                    recv_line()
                except (BrokenPipeError, OSError):
                    pass

        except SQLCraftSQLGenError:
            raise
        except Exception as e:
            if "Server closed" in str(e):
                raise SQLCraftConnectedError(
                    f"SQL generator connection error: {e}. "
                    f"This may be caused by invalid rules."
                )
            raise SQLCraftConnectedError(
                f"Error connecting to SQL generator: {e}"
            )

        return result

    def get_trained_features_path(self) -> str:
        return os.path.join(self._config.work_dir, "trained_features.json")

    def read_trained_features(self) -> dict:
        path = self.get_trained_features_path()
        if not os.path.exists(path):
            return {}
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)

    def write_trained_features(self, data: dict) -> None:
        path = self.get_trained_features_path()
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)


class MCPClient:
    def __init__(self, config: AppConfig, driver: DBMSDriver):
        self._config = config
        self._driver = driver
        self._sql_nums: int = 30

        self._sqlcraft_dir = os.path.normpath(os.path.join(
            os.path.dirname(os.path.abspath(__file__)),
            "..", "configs", "sqlcraft", config.dbms
        ))
        if not os.path.exists(self._sqlcraft_dir):
            raise FileNotFoundError(
                f"SQLCraft config directory not found: {self._sqlcraft_dir}"
            )
        self._generator = SQLGenerator(config, self._sqlcraft_dir)

    def get_supported_datatypes(self) -> list[str]:
        return list(self._generator.supported_datatypes)

    def get_supported_aggregate_evaluators(self) -> list[str]:
        trained = self._generator.read_trained_features()
        result: set[str] = set()
        for syntax_name in trained:
            for type_eval in trained[syntax_name].get("eval2lefts", {}):
                if type_eval.endswith("_AGG_evaluator"):
                    result.add(type_eval)
        return sorted(result)

    def test_rule(
        self, rule_path: str, const_path: str,
        jar: "JARInstance", sql_nums: int | None = None,
    ) -> TestResult:
        sql_nums = sql_nums if sql_nums is not None else self._sql_nums

        with open(rule_path, "r", encoding="utf-8") as f:
            target_rule = json.load(f)
        with open(const_path, "r", encoding="utf-8") as f:
            const_rule = json.load(f)
        trained = self._generator.read_trained_features()

        logs: list[str] = []

        try:
            jar_gen = SQLGenerator(self._config, jar.config_dir)

            idx = jar_gen.generate_grammar(trained, target_rule, const_rule)

            generated_sqls = jar_gen.generate_sqls(
                target_rule["left"], idx, sql_nums, jar.port
            )

            conn = self._driver.get_conn()
            error_count = 0
            try:
                for sql in generated_sqls:
                    result, rowcount = self._driver.execute(sql, conn)
                    if rowcount < -1 and self._driver.error_check(result):
                        logs.append(
                            f"Error occurs when executing SQL: {sql}\n"
                            f"Error message: {result}"
                        )
                        error_count += 1
            finally:
                try:
                    conn.close()
                except Exception:
                    pass

            total = len(generated_sqls)
            accuracy = (total - error_count) / total if total > 0 else 0.0
            logs.append(f"Acc rate: {accuracy}")

        except SQLCraftSQLGenError as e:
            logs.append(str(e))
            accuracy = 0.0
        except SQLCraftConnectedError as e:
            logs.append(str(e))
            accuracy = 0.0

        return TestResult.from_logs(logs)

    def save_rule(self, rule_path: str, const_path: str) -> str:
        target_rule_dir = os.path.dirname(rule_path)
        basic_info_path = os.path.join(target_rule_dir, "basic_info.json")

        with open(basic_info_path, "r", encoding="utf-8") as f:
            basic_info = json.load(f)
        with open(rule_path, "r", encoding="utf-8") as f:
            target_rule = json.load(f)
        with open(const_path, "r", encoding="utf-8") as f:
            const_rule = json.load(f)

        trained = self._generator.read_trained_features()

        syntax_name = basic_info["syntax_name"]
        type_eval = target_rule["type_eval"]
        left = target_rule["left"]
        right = target_rule["right"]

        import copy

        if syntax_name not in trained:
            trained[syntax_name] = copy.deepcopy(basic_info)
            trained[syntax_name]["eval2lefts"] = {type_eval: [left]}
            trained[syntax_name]["left2rights"] = {left: [right]}
            trained[syntax_name]["const_prods"] = const_rule
        else:
            if type_eval not in trained[syntax_name]["eval2lefts"]:
                trained[syntax_name]["eval2lefts"][type_eval] = []
            if left not in trained[syntax_name]["eval2lefts"][type_eval]:
                trained[syntax_name]["eval2lefts"][type_eval].append(left)
            if left not in trained[syntax_name]["left2rights"]:
                trained[syntax_name]["left2rights"][left] = []
            if right not in trained[syntax_name]["left2rights"][left]:
                trained[syntax_name]["left2rights"][left].append(right)
            trained[syntax_name]["const_prods"] = const_rule

        self._generator.write_trained_features(trained)
        return "Done!"

def _resolve_path(base_dir: str, rel_path: str) -> str:
    if os.path.isabs(rel_path):
        return rel_path
    return os.path.normpath(os.path.join(base_dir, rel_path))
