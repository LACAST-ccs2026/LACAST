import os

from nodes.single_pipeline import single_rule_pipeline


def fan_out_rules_node(state) -> dict:
    from utils.log import log

    rules = state.get("generated_rules", [])
    feature_dir = state.get("feature_dir_path", "")
    const_file = os.path.join(feature_dir, "const_productions.json")

    log.info(f"    Testing rules: {len(rules)}")

    merged = {"rule_results": [], "failed_results": [], "fix_episodes": []}

    for rule in rules:
        inp = {
            "rule": rule,
            "rule_file_path": rule["rule_file_path"],
            "const_file_path": const_file,
            "max_fix_attempts": 3,
        }
        out = single_rule_pipeline(inp, state)
        for k in merged:
            merged[k].extend(out.get(k, []))

    log.info(f"    Results: passed={len(merged['rule_results'])}, "
             f"failed={len(merged['failed_results'])}, "
             f"fix_episodes={len(merged['fix_episodes'])}")

    return merged

