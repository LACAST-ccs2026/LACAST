import argparse
import os

from config import AppConfig, DBMSConfig
from graph import build_main_graph
from services.jar_pool import JarPool
from services.memory_store import MemoryStoreSQLite
from utils.dbms_driver import create_driver
from utils.llm_client import LLMClient
from utils.mcp_client import MCPClient
from state import MainState


def main():
    parser = argparse.ArgumentParser(description="SQL Rule Generator")
    parser.add_argument("--dbms", required=True, help="Target DBMS, e.g. sqlite, mysql, mariadb, postgres, tidb")
    parser.add_argument(
        "--work-dir", required=True, help="Working directory for the DBMS"
    )
    parser.add_argument(
        "--limit", type=int, default=0,
        help="Maximum N features to train (0=unlimited, default 0)"
    )
    parser.add_argument(
        "--timeout", type=int, default=0,
        help="Timeout in minutes (0 or -1=unlimited, default 0. Completes current feature, progress saved)"
    )
    parser.add_argument(
        "--no-fix", action="store_true", default=False,
        help="Skip fix step (ablation study): discard failed rules without LLM repair"
    )
    args = parser.parse_args()

    config = AppConfig(dbms=args.dbms, work_dir=args.work_dir)
    config.validate()
    print(f"[init] DBMS={config.dbms}, work_dir={config.work_dir}")

    from utils.log import init_log
    init_log(args.work_dir)

    db_conf = DBMSConfig.from_yaml(args.dbms)

    sqlcraft_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "configs", "sqlcraft", config.dbms,
    )
    schema_path = os.path.join(sqlcraft_dir, "schema", "2.sql")

    if args.dbms == "sqlite":
        db_path = db_conf.db_path or os.path.join(sqlcraft_dir, "schema", "sqlite.db")
        driver = create_driver("sqlite", db_path=db_path, schema_path=schema_path)
    elif args.dbms in ("mysql", "mariadb", "tidb"):
        driver = create_driver(
            args.dbms,
            host=db_conf.host,
            port=db_conf.port,
            username=db_conf.username,
            password=db_conf.password,
            database_name=db_conf.database_name,
            schema_path=schema_path,
        )
    elif args.dbms in ("postgres", "postgresql"):
        driver = create_driver(
            "postgres",
            host=db_conf.host,
            port=db_conf.port,
            username=db_conf.username,
            password=db_conf.password,
            database_name=db_conf.database_name,
            schema_path=schema_path,
        )
    else:
        raise ValueError(f"Unsupported DBMS: {args.dbms}")

    driver.build_schema()
    print("[init] DBMS driver ready")

    mcp = MCPClient(config, driver)
    print("[init] MCP client ready (datatypes:", mcp.get_supported_datatypes(), ")")

    llm = LLMClient(config.llm)
    print("[init] LLM client ready")

    memory_store = MemoryStoreSQLite(config.memory_db_path)

    jar_pool = JarPool(config)
    print(f"[init] JAR pool ready ({jar_pool.instance_count} instances)")

    graph = build_main_graph(
        config=config,
        driver=driver,
        mcp=mcp,
        llm=llm,
        memory_store=memory_store,
        jar_pool=jar_pool,
    )
    print("[init] Graph compiled")

    initial = MainState(
        dbms=config.dbms,
        work_dir=config.work_dir,
        limit=args.limit,
        timeout=args.timeout * 60,
        start_time=0,
        no_fix=args.no_fix,
        all_features=[],
        untrained_features=[],
        completed_features=[],
        failed_features=[],
        current_feature=None,
        subgraph_output=None,
        is_done=False,
        latest_progress="",
    )

    print("\n=== Starting training ===\n")
    result = graph.invoke(initial)

    from utils.grammar_exporter import GrammarExporter
    try:
        exporter = GrammarExporter(config.dbms, config.work_dir)
        exporter.export()
    except Exception as e:
        print(f"[warn] Grammar export failed: {e}")

    print(f"\n=== Training complete ===")
    completed = result.get("completed_features", [])
    failed = result.get("failed_features", [])
    print(f"Completed: {len(completed)} features")
    for name in completed:
        print(f"  OK {name}")
    print(f"Failed: {len(failed)} features")
    for f in failed:
        print(f"  FAIL {f['raw_syntax_name']}: {f['reason']}")

    jar_pool.shutdown()
    print("[done] JAR pool shut down")


if __name__ == "__main__":
    main()

