import json
import os
from datetime import datetime, timezone
from typing import Any


def read_json(path: str) -> Any:
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def write_json(path: str, data: Any, indent: int = 2) -> None:
    ensure_dir(os.path.dirname(path))
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=indent, ensure_ascii=False)


def ensure_dir(path: str) -> None:
    if path and not os.path.exists(path):
        os.makedirs(path, exist_ok=True)


TRAINING_STATE_FILENAME = "training_state.json"


def _empty_training_state(dbms: str) -> dict:
    return {
        "dbms": dbms,
        "updated_at": datetime.now(timezone.utc).isoformat(),
        "completed_features": [],
        "failed_features": [],
    }


def read_training_state(work_dir: str, dbms: str) -> dict:
    path = os.path.join(work_dir, TRAINING_STATE_FILENAME)

    if not os.path.exists(path):
        ensure_dir(work_dir)
        empty = _empty_training_state(dbms)
        write_json(path, empty)
        return empty

    return read_json(path)


def write_training_state(
    work_dir: str,
    dbms: str,
    completed: list[str],
    failed: list[dict],
) -> None:
    data = {
        "dbms": dbms,
        "updated_at": datetime.now(timezone.utc).isoformat(),
        "completed_features": completed,
        "failed_features": failed,
    }
    write_json(os.path.join(work_dir, TRAINING_STATE_FILENAME), data)
