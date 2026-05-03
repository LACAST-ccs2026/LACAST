import os


def save_results_node(state) -> dict:
    from nodes._inject import _mcp, _memory_store
    from utils.log import log

    results = state.get("rule_results", [])
    log.info(f"    save_results: {len(results)} passed")

    saved = 0
    for result in results:
        if result.get("status") == "passed":
            feature_dir = state.get("feature_dir_path", "")
            rule_path = os.path.join(feature_dir, f"rule_{result['rule_idx']}.json")
            const_path = os.path.join(feature_dir, "const_productions.json")
            if _mcp:
                _mcp.save_rule(rule_path, const_path)
            saved += 1
            log.debug(f"    save_results: rule_{result['rule_idx']} saved")

    episodes = state.get("fix_episodes", [])
    for episode in episodes:
        if _memory_store:
            _memory_store.save_episode(episode)

    if episodes:
        log.debug(f"    save_results: {len(episodes)} fix episodes written to Memory")

    return {"status": "completed", "saved_count": saved, "phase": "saving"}

