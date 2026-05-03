from prompts import loadf


def summarize_failure_node(state) -> dict:
    from nodes._inject import _llm

    errors = [
        r.get("error_summary", "")
        for r in state.get("failed_results", [])
    ]
    text = "; ".join(errors) if errors else "no error details"

    summary = ""
    if _llm:
        summary = _llm.generate_text(
            loadf("summarize_failure", errors=text)
        )

    return {
        "status": "failed",
        "failure_summary": summary or f"All rule tests failed: {text[:200]}",
        "saved_count": 0,
        "phase": "saving",
    }

