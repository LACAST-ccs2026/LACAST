from typing import Optional


class EventStore:
    def __init__(self):
        self._events: dict[str, list[dict]] = {}

    def append(self, task_id: str, event: dict) -> None:
        if task_id not in self._events:
            self._events[task_id] = []
        self._events[task_id].append(event)

    def get_events(
        self, task_id: str, since: Optional[str] = None
    ) -> list[dict]:
        events = self._events.get(task_id, [])

        if since is None:
            return list(events)

        return [e for e in events if e.get("timestamp", "") > since]

    def clear(self, task_id: str) -> None:
        self._events.pop(task_id, None)

    @property
    def active_tasks(self) -> list[str]:
        return list(self._events.keys())


_default_store: Optional[EventStore] = None


def get_event_store() -> EventStore:
    global _default_store
    if _default_store is None:
        _default_store = EventStore()
    return _default_store
