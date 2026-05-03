import argparse
import os
from db_manager import DatabaseManager
from llm_client import LLMClient
from fuzzer import Fuzzer
from results_logger import ResultsLogger


def main():
    parser = argparse.ArgumentParser(description="LLM-SQL-Fuzzer")
    parser.add_argument(
        "--dbms",
        required=True,
        choices=["mysql", "mariadb", "sqlite", "postgres", "tidb"],
        help="Target DBMS",
    )
    parser.add_argument(
        "--duration", type=int, default=60, help="Running duration in minutes"
    )
    args = parser.parse_args()

    if not os.path.exists("results"):
        os.makedirs("results")

    db_manager = DatabaseManager(args.dbms)
    llm_client = LLMClient()
    results_logger = ResultsLogger(args.dbms)
    fuzzer = Fuzzer(db_manager, llm_client, results_logger, args.dbms)

    print(f"Initializing schema for {args.dbms}...")
    db_manager.init_schema()
    print("Schema initialized.")

    print(f"Starting fuzzer for {args.dbms} for {args.duration} minutes...")
    fuzzer.run(args.duration * 60)
    print("Fuzzing finished.")

    results_logger.save_statistics()
    print("Statistics saved.")


if __name__ == "__main__":
    main()
