import time

from state import FailedInfo, FeatureInfo, MainState
from utils.file_utils import read_json, read_training_state


def init_node(state: MainState) -> dict:
    work_dir = state["work_dir"]
    dbms = state["dbms"]

    web_path = f"{work_dir}/web_corpus.json"
    corpus = read_json(web_path)

    all_features: list[FeatureInfo] = []
    for syntax_type, items in corpus.items():
        for raw_name, infos in items.items():
            is_agg = "AGG" in syntax_type.upper() or "aggregate" in syntax_type.lower()
            syntax_info = infos[0] if isinstance(infos, list) and infos else ""

            all_features.append(FeatureInfo(
                raw_syntax_name=raw_name,
                syntax_type=syntax_type,
                is_agg=is_agg,
                syntax_info=syntax_info,
            ))

    all_features.sort(key=lambda f: (not f["is_agg"], f["raw_syntax_name"]))

    ts = read_training_state(work_dir, dbms)
    completed_set = set(ts.get("completed_features", []))
    failed_set = {
        f["raw_syntax_name"] for f in ts.get("failed_features", [])
    }

    untrained = [
        f["raw_syntax_name"] for f in all_features
        if f["raw_syntax_name"] not in completed_set
        and f["raw_syntax_name"] not in failed_set
    ]

    limit = state.get("limit", 0)
    if limit > 0:
        untrained = untrained[:limit]

    failed_list = [FailedInfo(raw_syntax_name=f["raw_syntax_name"], reason=f["reason"])
                   for f in ts.get("failed_features", [])]

    return {
        "all_features": all_features,
        "untrained_features": untrained,
        "completed_features": list(completed_set),
        "failed_features": failed_list,
        "start_time": time.time(),
        "is_done": len(untrained) == 0,
        "latest_progress": (
            f"Initialization completed: {len(all_features)} features in total, "
            f"{len(completed_set)} completed, "
            f"{len(untrained)} pending training"
        ),
    }

