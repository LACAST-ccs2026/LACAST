import json
import os
import threading
import time
import uuid
from collections import defaultdict


class Record:
    def __init__(self, output_dir):
        self.lock = threading.Lock()
        self.output_dir = output_dir
        self.record_path = os.path.join(output_dir, "record.json")
        if os.path.exists(self.record_path):
            with open(self.record_path, "r") as f:
                self.record = json.load(f)
            self.record["running_history"].append([self.record["cur_start_time"], self.record["cur_end_time"]])
            self.record["cur_start_time"] = time.time()
            self.record["cur_end_time"] = self.record["cur_start_time"]
        else:
            self.record = {
                "total_sql_num": 0,
                "error_sql_num": 0,
                "error_type_num": 0,
                "crash_num": 0,
                "generated_sql_num_per_epoch": 0,
                "accuracy": 0.0,
                "radar_sql_num": 0,
                "running_history":[],
                "cur_start_time": time.time(),
                "cur_end_time": time.time()
            }

    def update1(self, new_sql_num, new_error_sql_num, error_type_num):
        with self.lock:
            self.record["total_sql_num"] += new_sql_num
            self.record["error_sql_num"] += new_error_sql_num
            self.record["error_type_num"] = error_type_num
            self.record["accuracy"] = 0 if self.record["total_sql_num"] == 0 else (self.record["total_sql_num"] - self.record["error_sql_num"]) / self.record["total_sql_num"]

    def update2(self, generated_sql_num_per_epoch):
        with self.lock:
            self.record["generated_sql_num_per_epoch"] = generated_sql_num_per_epoch

    def update3(self, custom_kv):
        with self.lock:
            for k, v in custom_kv.items():
                if k not in self.record:
                    self.record[k] = v
                else:
                    self.record[k] += v

    def update4(self, radar_sql_num):
        with self.lock:
            self.record["radar_sql_num"] = radar_sql_num
            self.record["accuracy"] = 0 if self.record["total_sql_num"] == 0 else (self.record["total_sql_num"] - self.record["error_sql_num"]) / self.record["total_sql_num"]

    def increase_total_sql_num(self):
        with self.lock:
            self.record["total_sql_num"] += 1

    def increase_crash_num(self):
        with self.lock:
            self.record["crash_num"] += 1

    def dump(self):
        with self.lock:
            with open(self.record_path, "w") as f:
                json.dump(self.record, f, indent=4, ensure_ascii=False)

    def to_str(self):
        return " ".join(f"{k}: {v}" for k, v in self.record.items())

    def mark_end_time(self):
        self.record["cur_end_time"] = time.time()

class ErrorRecord:
    def __init__(self, output_dir):
        self.lock = threading.Lock()
        self.output_dir = output_dir
        self.error_output_dir = os.path.join(self.output_dir, "errors")
        if not os.path.exists(self.error_output_dir):
            os.makedirs(self.error_output_dir)
        self.error_id_mapping_path = os.path.join(self.output_dir, "error_id_mapping.json")

        if os.path.exists(self.error_id_mapping_path):
            with open(file=self.error_id_mapping_path, mode="r", encoding="utf-8") as f:
                error_id_mapping_data = json.load(f)
            self.error_id_mapping = defaultdict(lambda: {"id": str(uuid.uuid4()), "count": 0}, error_id_mapping_data)
        else:
            self.error_id_mapping = defaultdict(lambda: {"id": str(uuid.uuid4()), "count": 0})


    def get_error_type_count(self):
        return len(self.error_id_mapping)

    def record_error(self, error_sql, error_info, schema_dir):
        with self.lock:
            self.error_id_mapping[error_info]["count"] += 1
            error_id = self.error_id_mapping[error_info]["id"]
            with open(file=os.path.join(self.error_output_dir, f"{error_id}.txt"), mode="a", encoding="utf-8") as f:
                f.write(f"{error_sql} schema_dir: {schema_dir}\n")

    def dump(self):
        with self.lock:
            with open(file=self.error_id_mapping_path, mode="w", encoding="utf-8") as f:
                json.dump(self.error_id_mapping, f, indent=4, ensure_ascii=False)

class RadarRecord:
    def __init__(self, output_dir):
        self.lock = threading.Lock()
        self.output_dir = output_dir
        self.radar_record_path = os.path.join(self.output_dir, "radar_record.jsonl")
        self.radar_sqls = list()
        if os.path.exists(self.radar_record_path):
            with open(file=self.radar_record_path, mode="r", encoding="utf-8") as f:
                self.radar_num = len(list(f))
        else:
            self.radar_num = 0

    # def record(self, sql, schema_dir, result1, rowcount1, result2, rowcount2):
    #     with self.lock:
    #         self.radar_sqls.append({"sql": sql, "schema_dir": schema_dir, "result1": result1, "rowcount1": rowcount1, "result2": result2, "rowcount2": rowcount2})
    #         self.radar_num += 1

    def record(self, sql, error_info, schema_dir):
        with self.lock:
            self.radar_sqls.append({"sql": sql, "schema_dir": schema_dir, "error_info": error_info})
            self.radar_num += 1

    def dump(self):
        with self.lock:
            if len(self.radar_sqls) > 0:
                with open(file=self.radar_record_path, mode="a", encoding="utf-8") as f:
                    for radar_sql in self.radar_sqls:
                        f.write(json.dumps(radar_sql, ensure_ascii=False)+"\n")
                self.radar_sqls = list()


class ThroughputCount:
    def __init__(self):
        self.start_time = time.time()
        self.end_time = time.time()
        self.count = 0
        self.last_throughput = 0
        self.lock = threading.Lock()

    def start(self):
        with self.lock:
            self.count = 0
            self.start_time = time.time()

    def mark(self, count):
        with self.lock:
            self.end_time = time.time()
            self.count = count

    def generate_throughput(self):
        with self.lock:
            self.last_throughput = self.count / (self.end_time - self.start_time)

    def get_throughput(self):
        return self.last_throughput