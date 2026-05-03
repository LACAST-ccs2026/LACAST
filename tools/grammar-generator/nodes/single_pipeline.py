import json
from datetime import datetime, timezone
from uuid import uuid4

from langchain_core.exceptions import OutputParserException

from prompts import load, loadf


def single_rule_pipeline(input_data, state) -> dict:
    from nodes._inject import _mcp, _llm, _memory_store, _jar
    from utils.llm_client import TestVerdict, FixOutput
    from utils.log import log

    rule = input_data["rule"]
    max_attempts = input_data.get("max_fix_attempts", 3)
    dbms = state["dbms"]
    syntax_name = state["syntax_name"]
    rule_file = input_data["rule_file_path"]
    const_file = input_data["const_file_path"]
    rule_idx = rule.get("idx", 0)

    log.info(f"    pipeline[{rule_idx}]: {rule.get('left', '?')}")

    fix_history = []
    current_rule = dict(rule)
    fix_info = []

    for attempt in range(max_attempts + 1):
        log.info(f"      test[{rule_idx}] attempt={attempt}")
        test_result = _mcp.test_rule(rule_file, const_file, _jar, sql_nums=30)
        log.debug(f"      test[{rule_idx}] accuracy={test_result.accuracy}, passed={test_result.passed}")
        log.debug(f"      test[{rule_idx}] logs: {'; '.join(test_result.logs[:3])}")

        if test_result.passed:
            log.info(f"      pipeline[{rule_idx}] [PASS] passed")
            for fi in fix_info:
                episode = _build_episode(fi, state, syntax_name, dbms, success=True)
                fix_history.append(episode)
            return _passed(current_rule, test_result, fix_history)

        if state.get("no_fix", False):
            log.info(f"      pipeline[{rule_idx}] [NOFIX] no_fix mode, discarding")
            break

        if attempt == max_attempts:
            log.info(f"      pipeline[{rule_idx}] [FAIL] max fix attempts exceeded, discarding")
            for fi in fix_info:
                episode = _build_episode(fi, state, syntax_name, dbms, success=False)
                fix_history.append(episode)
            break

        if any("server closed" in l.lower() or "connection error" in l.lower()
               for l in test_result.logs):
            log.info(f"      pipeline[{rule_idx}] [FAIL] JAR connection lost, discarding and restarting")
            from nodes._inject import _jar_pool as _jp
            if _jp and _jar:
                try:
                    _jp._restart(_jar)
                    log.info(f"      pipeline[{rule_idx}] JAR {_jar.port} restarted")
                except Exception as e:
                    log.warn(f"      pipeline[{rule_idx}] JAR restart failed: {e}")
            break

        log.info(f"      evaluate[{rule_idx}] attempt={attempt}")
        try:
            verdict = _llm.generate_structured(
                [
                    {"role": "system", "content": load("evaluate_verdict")},
                    {
                        "role": "user",
                        "content": (
                            f"Rule: type_eval={current_rule['type_eval']}, "
                            f"left={current_rule['left']}, "
                            f"right={current_rule['right']}\n"
                            f"Test logs: {'; '.join(test_result.logs)}"
                        ),
                    },
                ],
                TestVerdict,
                temperature=0.0,
            )
        except OutputParserException as e:
            log.warn(f"      evaluate[{rule_idx}] LLM returned invalid JSON: {e}")
            verdict = TestVerdict(
                status="fail", accuracy=0.0,
                summary="LLM evaluation failed",
                error_type="unknown",
            )
        log.info(f"      evaluate[{rule_idx}] error_type={verdict.error_type}")

        memory_context = ""
        if attempt >= 1:
            query = type("SQ", (), {
                "dbms": dbms, "error_type": verdict.error_type,
                "syntax_type": state["feature_info"]["syntax_type"],
                "top_k": 3, "semantic_first": False,
            })()
            memory_hits = _memory_store.search_episodes(query)
            if memory_hits:
                snippets = "\n".join(
                    f"- {h.get('fix', {}).get('fix_summary', '')}"
                    for h in memory_hits[:2]
                )
                memory_context = f"\nPrevious similar fixes:\n{snippets}"
                log.debug(f"      memory[{rule_idx}] hit {len(memory_hits)} items")

        log.info(f"      fix[{rule_idx}] attempt={attempt}")
        fix_prompt = loadf(
            "fix_rule",
            supported_datatypes=", ".join(_mcp.get_supported_datatypes()),
        ) + memory_context

        try:
            fix = _llm.generate_structured(
                [
                    {"role": "system", "content": fix_prompt},
                    {
                        "role": "user",
                        "content": (
                            f"Rule: type_eval={current_rule['type_eval']}, "
                            f"left={current_rule['left']}, "
                            f"right={current_rule['right']}\n"
                            f"Error summary: {verdict.summary}\n"
                            f"Error type: {verdict.error_type}"
                        ),
                    },
                ],
                FixOutput,
            )
        except OutputParserException as e:
            log.warn(f"      fix[{rule_idx}] LLM returned invalid JSON: {e}")
            fix = FixOutput(
                type_eval=current_rule["type_eval"],
                left=current_rule["left"],
                right=current_rule["right"],
                status="cannot_fix",
            )

        if fix.status == "cannot_fix":
            log.info(f"      fix[{rule_idx}] [CANT_FIX] cannot fix")
            break

        log.info(f"      fix[{rule_idx}] [FIXED] fix succeeded")

        fix_info.append({
            "fix": fix,
            "verdict": verdict,
            "rule_before": dict(current_rule),
            "test_result": test_result,
            "attempt": attempt,
        })

        current_rule = {
            "type_eval": fix.type_eval,
            "left": fix.left,
            "right": fix.right,
        }
        with open(rule_file, "w", encoding="utf-8") as f:
            json.dump(current_rule, f, indent=2, ensure_ascii=False)

        if fix.const_productions:

            const_file = input_data.get("const_file_path",
                                         state.get("feature_dir_path", "")
                                         + "/const_productions.json")
            with open(const_file, "w", encoding="utf-8") as f:
                json.dump(fix.const_productions, f, indent=2, ensure_ascii=False)
            log.debug(f"      const[{rule_idx}] const_productions updated")

    log.info(f"      pipeline[{rule_idx}] [DISCARD] final failure")
    return _failed(current_rule, test_result, fix_history)


def _rule_signature(right: str) -> str:
    import re
    vars_ = re.findall(r"_var_(\w+)", right)
    evals = re.findall(r"(\w+)_evaluator", right)
    parts = []
    if "_AGG_" in right or "AGG_" in right:
        parts.append("agg")
    if vars_:
        parts.append(f"var{len(vars_)}")
    if evals:
        parts.append(f"expr{len(evals)}")
    return "_".join(parts) if parts else "simple"


def _build_episode(fi: dict, state, syntax_name: str, dbms: str,
                   success: bool) -> dict:
    fix = fi["fix"]
    verdict = fi["verdict"]
    rule_before = fi["rule_before"]
    test_result = fi["test_result"]
    attempt = fi["attempt"]
    return {
        "episode_id": f"ep_{uuid4().hex[:12]}",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "context": {
            "dbms": dbms,
            "syntax_type": state["feature_info"]["syntax_type"],
            "syntax_name": syntax_name,
            "raw_syntax_name": state["feature_info"]["raw_syntax_name"],
            "rule_signature": _rule_signature(rule_before.get("right", "")),
            "return_type": rule_before.get("type_eval", ""),
            "is_agg": state["feature_info"]["is_agg"],
        },
        "error": {
            "error_type": verdict.error_type or "unknown",
            "error_message": verdict.summary,
            "error_summary": "; ".join(test_result.logs),
            "rule_before": rule_before,
        },
        "fix": {
            "fix_attempts": attempt + 1,
            "rule_after": {
                "type_eval": fix.type_eval,
                "left": fix.left,
                "right": fix.right,
            },
            "fix_actions": fix.fix_actions or [],
            "fix_summary": fix.fix_summary,
            "success": success,
        },
        "usage": {"hit_count": 0, "last_hit": None},
    }


def _passed(rule, test_result, fix_history):
    return {
        "rule_results": [{
            "rule_idx": rule.get("idx", 0),
            "status": "passed",
            "accuracy": test_result.accuracy,
            "error_info": None,
            "error_summary": None,
            "test_log": test_result.logs,
            "fix_episode": fix_history[-1] if fix_history else None,
        }],
        "fix_episodes": fix_history,
    }


def _failed(rule, test_result, fix_history):
    return {
        "failed_results": [{
            "rule_idx": rule.get("idx", 0),
            "status": "discarded",
            "accuracy": test_result.accuracy,
            "error_info": test_result.error_summary,
            "error_summary": "; ".join(test_result.logs),
            "test_log": test_result.logs,
            "fix_episode": fix_history[-1] if fix_history else None,
        }],
        "fix_episodes": fix_history,
    }

