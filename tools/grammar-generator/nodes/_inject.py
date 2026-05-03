from typing import Optional

_mcp: Optional[object] = None
_memory_store: Optional[object] = None
_llm: Optional[object] = None
_jar: Optional[object] = None
_jar_pool: Optional[object] = None


def inject(mcp=None, memory_store=None, llm=None, jar=None, jar_pool=None):
    global _mcp, _memory_store, _llm, _jar, _jar_pool
    if mcp is not None:
        _mcp = mcp
    if memory_store is not None:
        _memory_store = memory_store
    if llm is not None:
        _llm = llm
    if jar is not None:
        _jar = jar
    if jar_pool is not None:
        _jar_pool = jar_pool


def reset():
    global _mcp, _memory_store, _llm, _jar, _jar_pool
    _mcp = _memory_store = _llm = _jar = _jar_pool = None
