import time
import json
import os


class Fuzzer:
    def __init__(self, db_manager, llm_client, results_logger, dbms):
        self.db_manager = db_manager
        self.llm_client = llm_client
        self.results_logger = results_logger
        self.dbms = dbms
        self.schema = self._load_schema()

    def _load_schema(self):
        schema_path = os.path.join("schemas", self.dbms, "1.json")
        with open(schema_path, "r") as f:
            return json.load(f)

    def run(self, duration):
        start_time = time.time()
        conn = self.db_manager.get_conn()
        try:
            while time.time() - start_time < duration:
                generation_start_time = time.time()

                (
                    sql,
                    raw_sql,
                    prompt_tokens,
                    completion_tokens,
                ) = self.llm_client.generate_sql(self.dbms, self.schema)

                generation_time = time.time() - generation_start_time

                if sql:
                    result, rowcount = self.db_manager.execute_sql(sql, conn)
                    success = rowcount > -100
                    error_message = result if not success else ""

                    self.results_logger.log(
                        sql=sql,
                        raw_sql=raw_sql,
                        success=success,
                        error_message=error_message,
                        generation_time=generation_time,
                        prompt_tokens=prompt_tokens,
                        completion_tokens=completion_tokens,
                    )

                    status = "Success" if success else f"Failed ({error_message})"
                    print(f"Generated SQL: {sql.strip()} -> {status}")
        finally:
            if conn:
                conn.close()
