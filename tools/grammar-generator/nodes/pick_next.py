from state import MainState


def pick_next_feature(state: MainState) -> dict:
    untrained = state["untrained_features"]

    if not untrained:
        return {
            "is_done": True,
            "current_feature": None,
            "latest_progress": "All features trained",
        }

    raw_name = untrained[0]
    feature = next(
        f for f in state["all_features"] if f["raw_syntax_name"] == raw_name
    )
    remaining = untrained[1:]

    done = len(remaining) == 0

    return {
        "current_feature": feature,
        "untrained_features": remaining,
        "is_done": False,
        "latest_progress": f"Training feature: {raw_name}",
    }

