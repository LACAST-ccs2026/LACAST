from langgraph.graph import END, StateGraph

from nodes._inject import inject
from nodes.init_node import init_node
from nodes.pick_next import pick_next_feature
from nodes.record_result import record_result
from nodes.select_feature import select_feature_node
from nodes.generate_rules import generate_rules_node
from nodes.fan_out import fan_out_rules_node
from nodes.fan_in import fan_in_collect_results
from nodes.save_results import save_results_node
from nodes.summarize_failure import summarize_failure_node
from state import MainState, FeatureTrainerState


def build_trainer_subgraph() -> StateGraph:
    builder = StateGraph(FeatureTrainerState)

    builder.add_node("select_feature", select_feature_node)
    builder.add_node("generate_rules", generate_rules_node)
    builder.add_node("fan_out", fan_out_rules_node)
    builder.add_node("fan_in", fan_in_collect_results)
    builder.add_node("save_results", save_results_node)
    builder.add_node("summarize_failure", summarize_failure_node)

    builder.set_entry_point("select_feature")
    builder.add_edge("select_feature", "generate_rules")
    builder.add_edge("generate_rules", "fan_out")
    builder.add_edge("fan_out", "fan_in")

    builder.add_conditional_edges(
        "fan_in",
        lambda s: "save" if s.get("status") == "completed" else "summarize",
        {"save": "save_results", "summarize": "summarize_failure"},
    )
    builder.add_edge("save_results", END)
    builder.add_edge("summarize_failure", END)

    return builder.compile()


def _prepare_subgraph_input(state: MainState) -> dict:
    feat = state.get("current_feature")
    if not feat:
        return {"status": "completed", "saved_count": 0, "total_rules": 0}
    return {
        "dbms": state["dbms"],
        "work_dir": state["work_dir"],
        "feature_info": feat,
        "no_fix": state.get("no_fix", False),
    }


trainer_graph = build_trainer_subgraph()


def _run_trainer(state: MainState) -> dict:
    from utils.log import log
    from nodes._inject import _jar_pool, inject as _inj

    input_state = _prepare_subgraph_input(state)
    if "status" in input_state and "saved_count" in input_state:
        return {"subgraph_output": {
            "status": "completed",
            "raw_syntax_name": state.get("current_feature", {}).get("raw_syntax_name", "?"),
            "syntax_name": "", "saved_count": 0, "total_rules": 0, "failure_summary": None,
        }}

    feat = state["current_feature"]
    raw = feat["raw_syntax_name"]
    log.info(f"→ Training feature: {raw}")

    jar = _jar_pool.acquire(timeout=30) if _jar_pool else None
    _inj(jar=jar)
    try:
        result = trainer_graph.invoke(input_state)
    finally:
        if jar and _jar_pool:
            _jar_pool.release(jar)
            log.debug(f"  JAR {jar.port} released")
        _inj(jar=None)

    status = result.get("status", "failed")
    saved = result.get("saved_count", 0)
    log.info(f"← Feature complete: {raw} | status={status} | saved={saved}")
    if status == "failed":
        log.warn(f"  Failure reason: {result.get('failure_summary', '(none)')}")

    return {"subgraph_output": {
        "status": status,
        "raw_syntax_name": feat["raw_syntax_name"],
        "syntax_name": result.get("syntax_name", ""),
        "saved_count": saved,
        "total_rules": result.get("total_rules", 0),
        "failure_summary": result.get("failure_summary"),
    }}


def build_main_graph(config=None, driver=None, mcp=None, llm=None, memory_store=None, jar_pool=None):
    inject(mcp=mcp, llm=llm, memory_store=memory_store, jar_pool=jar_pool)

    builder = StateGraph(MainState)
    builder.add_node("init", init_node)
    builder.add_node("pick_next", pick_next_feature)
    builder.add_node("feature_trainer", _run_trainer)
    builder.add_node("record_result", record_result)

    builder.set_entry_point("init")
    builder.add_edge("init", "pick_next")

    builder.add_conditional_edges(
        "pick_next",
        lambda s: "train" if not s.get("is_done") else "end",
        {"train": "feature_trainer", "end": END},
    )

    builder.add_edge("feature_trainer", "record_result")

    builder.add_conditional_edges(
        "record_result",
        lambda s: "continue" if not s.get("is_done") else "end",
        {"continue": "pick_next", "end": END},
    )

    return builder.compile()

