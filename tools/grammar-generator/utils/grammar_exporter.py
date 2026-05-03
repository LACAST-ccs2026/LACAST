import json
import os
import re
from collections import defaultdict


class GrammarExporter:
    def __init__(self, dbms: str, work_dir: str):
        self.dbms = dbms
        self.work_dir = work_dir

        _base = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self._sqlcraft_dir = os.path.normpath(
            os.path.join(_base, "configs", "sqlcraft", dbms)
        )

        cfg_path = os.path.join(self._sqlcraft_dir, "configs.json")
        with open(cfg_path, "r", encoding="utf-8") as f:
            self._cfg = json.load(f)

        types_path = os.path.join(self._sqlcraft_dir, self._cfg["typesJsonPath"])
        with open(types_path, "r", encoding="utf-8") as f:
            self._datatypes = json.load(f)["types"]

        base_path = os.path.join(self._sqlcraft_dir, "grammars", "base.g4")
        with open(base_path, "r", encoding="utf-8") as f:
            self._base_g4 = f.read()

        tf_path = os.path.join(work_dir, "trained_features.json")
        if os.path.exists(tf_path):
            with open(tf_path, "r", encoding="utf-8") as f:
                self._trained = json.load(f)
        else:
            self._trained = {}

    def build_grammar(self) -> str:
        productions: dict[str, list[str]] = defaultdict(list)

        for dt in self._datatypes:
            productions[f"{dt}_evaluator"].append(f"{dt}_evaluator_without_agg")
            productions[f"{dt}_evaluator_without_agg"].append(f"_var_{dt}")

        for rule in self._trained.values():
            for type_eval, lefts in rule.get("eval2lefts", {}).items():
                productions[type_eval].extend(lefts)
                match = re.match(r"([a-zA-Z0-9_]+)_AGG_evaluator", type_eval)
                if match:
                    dt = match.group(1)
                    if type_eval not in productions[f"{dt}_evaluator"]:
                        productions[f"{dt}_evaluator"].append(type_eval)
                        productions["agg_evaluator"].append(type_eval)
            for _left, _rights in rule.get("left2rights", {}).items():
                sanitized = [r.replace('\\"', '"') for r in _rights]
                if _left not in productions:
                    productions[_left] = []
                productions[_left].extend(sanitized)
            for k, v in rule.get("const_prods", {}).items():
                productions[k] = v

        grammar = f"{self._base_g4}\n\n"
        for _left, _rights in sorted(productions.items()):
            grammar += f"{_left}: {'|'.join(_rights)};\n"

        return grammar

    def export(self, output_path: str | None = None) -> str:
        if output_path is None:
            output_path = os.path.join(self.work_dir, "grammar.g4")

        grammar = self.build_grammar()
        os.makedirs(os.path.dirname(output_path) or ".", exist_ok=True)
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(grammar)

        from utils.log import log
        log.info(f"Grammar exported: {output_path} ({len(grammar)} bytes, "
                 f"{len(self._trained)} features)")

        return output_path


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Export complete grammar.g4")
    parser.add_argument("--dbms", required=True)
    parser.add_argument("--work-dir", required=True)
    parser.add_argument("--output", help="Output path (default: work-dir/grammar.g4)")
    args = parser.parse_args()

    from utils.log import init_log
    init_log(args.work_dir)

    exporter = GrammarExporter(args.dbms, args.work_dir)
    path = exporter.export(args.output)
    print(f"Done: {path}")
