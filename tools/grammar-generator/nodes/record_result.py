import time
from typing import Any

from state import FailedInfo
from utils.file_utils import write_training_state


def _fmt_failed(failed: list[Any]) -> list[dict]:
    result = []
    for f in failed:
        if isinstance(f, dict):
            result.append(f)
        else:
            result.append({"raw_syntax_name": f["raw_syntax_name"], "reason": f["reason"]})
    return result


def _fmt_completed(completed: list[Any]) -> list[str]:
    return [f if isinstance(f, str) else f["raw_syntax_name"] for f in completed]


def _check_timeout(state) -> tuple[bool, str]:
    timeout = state.get("timeout", 0)
    if timeout <= 0:
        return False, ""
    start = state.get("start_time", 0)
    if start == 0:
        return False, ""
    elapsed = time.time() - start
    if elapsed >= timeout:
        return True, f"Training timed out ({elapsed:.0f}s > {timeout}s). Current progress has been saved. Re-run to continue."
    return False, ""


def record_result(state) -> dict:
    output = state.get("subgraph_output")
    if not output:
        return {"current_feature": None, "latest_progress": "No subgraph result"}

    raw = output["raw_syntax_name"]
    dbms = state["dbms"]
    work_dir = state["work_dir"]

    completed = list(state.get("completed_features", []))
    failed = list(state.get("failed_features", []))

    if output.get("status") == "completed":
        completed = completed + [raw]
        progress = f"✓ Completed: {raw} ({output.get('saved_count', 0)} rules saved)"
    else:
        failed = failed + [FailedInfo(raw_syntax_name=raw, reason=output.get("failure_summary", "Unknown"))]
        progress = f"[FAIL] Failed: {raw}"

    write_training_state(work_dir, dbms, _fmt_completed(completed), _fmt_failed(failed))

    timed_out, timeout_msg = _check_timeout(state)
    if timed_out:
        progress = timeout_msg

    return {
        "completed_features": [raw] if output.get("status") == "completed" else [],
        "failed_features": (
            [FailedInfo(raw_syntax_name=raw, reason=output.get("failure_summary", "Unknown"))]
            if output.get("status") != "completed" else []
        ),
        "current_feature": None,
        "is_done": timed_out,
        "latest_progress": progress,
    }

