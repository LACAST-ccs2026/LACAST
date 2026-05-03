import json
import os

from prompts import load, loadf


def generate_rules_node(state) -> dict:
    from nodes._inject import _mcp, _llm
    from utils.llm_client import RulesOutput
    from utils.log import log

    fi = state["feature_info"]
    syntax_name = state["syntax_name"]
    feature_dir = state["feature_dir_path"]
    raw = fi["raw_syntax_name"]

    log.info(f"  Generating rules: {raw}")

    datatypes = _mcp.get_supported_datatypes()
    agg_evaluators = _mcp.get_supported_aggregate_evaluators()
    log.debug(f"    datatypes={datatypes}")
    log.debug(f"    agg_evals={agg_evaluators}")
    datatypes_str = ", ".join(datatypes)
    agg_evals_str = ", ".join(agg_evaluators) if agg_evaluators else "(none yet)"

    is_agg = fi["is_agg"]
    feature_name = fi.get("syntax_info", fi["raw_syntax_name"])
    syntax_type = fi["syntax_type"]

    warning = (
        "WARNING: No aggregate evaluators exist yet. "
        "Your rules MUST NOT reference any <datatype>_AGG_evaluator "
        "as parameters. Only use _var_<datatype> or <datatype>_evaluator_without_agg."
        if not agg_evaluators
        else "Available aggregate evaluators (use ONLY these if needed):"
    )

    system_prompt = load("generate_rules_system")
    user_prompt = loadf(
        "generate_rules_user",
        raw_syntax_name=fi["raw_syntax_name"],
        syntax_type=syntax_type,
        syntax_info=feature_name,
        is_agg=is_agg,
        syntax_name=syntax_name,
        datatypes=datatypes_str,
        agg_evaluators=agg_evals_str,
        WARNING=warning,
    )

    output = _llm.generate_structured(
        [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt},
        ],
        RulesOutput,
        temperature=0.3,
    )

    import re as _re
    valid_rules = []
    for r in output.rules:
        te = r.type_eval
        ok1 = bool(_re.match(r'^[a-z]+_(evaluator_without_agg|AGG_evaluator)$', te))
        ok2 = not _re.match(r'^[a-z]+_evaluator$', te)
        ok3 = not _re.match(r'^[a-z]+$', te)
        if not (ok1 and ok2 and ok3):
            log.warn(f"    Filtering invalid type_eval: '{te}'")
            continue
        ln = r.left
        lp = r.left.split("_")[0] if "_" in r.left else ""
        ok4 = len(r.left.split("_")) >= 2
        if not ok4:
            log.warn(f"    Filtering invalid left: '{ln}'")
            continue
        valid_rules.append(r)

    if not valid_rules:
        log.warn("    All rules filtered out, marking feature as failed")
        return {
            "generated_rules": [],
            "const_productions": output.const_productions,
            "phase": "generating",
            "total_rules": 0,
        }

    output.rules = valid_rules

    os.makedirs(feature_dir, exist_ok=True)
    generated_rules = []
    for i, rule in enumerate(output.rules):
        rule_path = os.path.join(feature_dir, f"rule_{i}.json")
        rule_dict = {
            "type_eval": rule.type_eval,
            "left": rule.left,
            "right": rule.right,
        }
        with open(rule_path, "w", encoding="utf-8") as f:
            json.dump(rule_dict, f, indent=2, ensure_ascii=False)

        generated_rules.append({
            "idx": i,
            "rule_file_path": rule_path,
            "type_eval": rule.type_eval,
            "left": rule.left,
            "right": rule.right,
        })

    const_path = os.path.join(feature_dir, "const_productions.json")
    with open(const_path, "w", encoding="utf-8") as f:
        json.dump(output.const_productions, f, indent=2, ensure_ascii=False)

    return {
        "generated_rules": generated_rules,
        "const_productions": output.const_productions,
        "phase": "generating",
        "total_rules": len(generated_rules),
    }

