from state import FeatureTrainerState


def fan_in_collect_results(state: FeatureTrainerState) -> dict:
    has_passed = len(state.get("rule_results", [])) > 0
    return {
        "phase": "collecting",
        "status": "completed" if has_passed else "pending",
    }

