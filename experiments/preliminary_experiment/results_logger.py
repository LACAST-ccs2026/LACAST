import json
import os
import time


class Statistics:
    def __init__(self):
        self.total_queries = 0
        self.successful_queries = 0
        self.total_generation_time = 0
        self.total_prompt_tokens = 0
        self.total_completion_tokens = 0

    def update(self, success, generation_time, prompt_tokens, completion_tokens):
        self.total_queries += 1
        if success:
            self.successful_queries += 1
        self.total_generation_time += generation_time
        self.total_prompt_tokens += prompt_tokens
        self.total_completion_tokens += completion_tokens

    def get_stats(self):
        accuracy = (
            (self.successful_queries / self.total_queries) * 100
            if self.total_queries > 0
            else 0
        )
        avg_generation_speed = (
            self.total_queries / self.total_generation_time
            if self.total_generation_time > 0
            else 0
        )
        avg_prompt_tokens = (
            self.total_prompt_tokens / self.total_queries
            if self.total_queries > 0
            else 0
        )
        avg_completion_tokens = (
            self.total_completion_tokens / self.total_queries
            if self.total_queries > 0
            else 0
        )

        return {
            "total_queries": self.total_queries,
            "successful_queries": self.successful_queries,
            "accuracy": f"{accuracy:.2f}%",
            "avg_generation_speed": f"{avg_generation_speed:.4f} queries/second",
            "avg_prompt_tokens": avg_prompt_tokens,
            "avg_completion_tokens": avg_completion_tokens,
            "total_prompt_tokens": self.total_prompt_tokens,
            "total_completion_tokens": self.total_completion_tokens,
        }


class ResultsLogger:
    def __init__(self, dbms):
        self.dbms = dbms
        self.filename = os.path.join("results", f"results_{self.dbms}.jsonl")
        self.stats = Statistics()
        self._init_file()

    def _init_file(self):
        if os.path.exists(self.filename):
            with open(self.filename, "r", encoding="utf-8") as f:
                for line in f:
                    log_entry = json.loads(line)
                    self.stats.update(
                        log_entry["success"],
                        log_entry["generation_time"],
                        log_entry["prompt_tokens"],
                        log_entry["completion_tokens"],
                    )

    def log(
        self,
        sql,
        raw_sql,
        success,
        error_message,
        generation_time,
        prompt_tokens,
        completion_tokens,
    ):
        self.stats.update(success, generation_time, prompt_tokens, completion_tokens)

        single_line_sql = " ".join(sql.split())

        log_entry = {
            "timestamp": time.time(),
            "sql": single_line_sql,
            "raw_sql": raw_sql,
            "success": success,
            "error_message": error_message,
            "generation_time": generation_time,
            "prompt_tokens": prompt_tokens,
            "completion_tokens": completion_tokens,
        }
        with open(self.filename, "a", encoding="utf-8") as f:
            f.write(json.dumps(log_entry, ensure_ascii=False) + "\n")

    def save_statistics(self):
        stats_filename = os.path.join("results", f"statistics_{self.dbms}.json")
        with open(stats_filename, "w", encoding="utf-8") as f:
            json.dump(self.stats.get_stats(), f, indent=4, ensure_ascii=False)
