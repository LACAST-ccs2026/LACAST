import logging
import os
import shutil
import sys
import threading
import time
import uuid
from multiprocessing import Process
from multiprocessing import Queue

import logging_util
from custom_error import JavaProgramError
from new_dashboard import RadarDashboard
from new_dbms_driver import DBMSDriver
from new_sql_generator import SQLGenerator
from record import Record, ErrorRecord, RadarRecord, ThroughputCount
from schema_generator import SchemaGenerator

NORMAL_ERR = "err"
SUCCESS_EXEC = "ok"
RADAR_ERR1 = "radar_err1"
RADAR_ERR2 = "radar_err2"
RADAR_ERR3 = "radar_err3"
TIMEOUT_ERR = "timeout"
CRASH_ERR = "crash"

SUCCESS_GEN = "ok"
ERR_GEN = "err_gen"

def worker_generate_sqls(sql_generator: SQLGenerator, nums: int, max_nums: int, result_q: Queue, output_path: str):
    _count = 0
    while _count < max_nums:
        try:
            result = sql_generator.call_sqlcraft(f"test: query 0 {nums}")
            _count += len(result)
            with open(file=output_path, mode="a", encoding="utf-8") as f:
                for sql in result:
                    f.write(f"{sql}\n")
                    result_q.put((SUCCESS_GEN, sql))
        except Exception as e:
            result_q.put((ERR_GEN, str(e)))


def worker_fuzzing(original_dbms_driver: DBMSDriver, raw_dbms_driver: DBMSDriver, sql: str, result_q: Queue):
    conn1 = None
    conn2 = None
    conn3 = None
    try:
        conn1 = original_dbms_driver.get_conn()
        conn2 = original_dbms_driver.get_conn()
        conn3 = raw_dbms_driver.get_conn()
    except Exception as e:
        if conn1:
            conn1.close()
        if conn2:
            conn2.close()
        if conn3:
            conn3.close()
        result_q.put((CRASH_ERR, sql, str(e)))
        return
    try:
        result1, rowcount1 = original_dbms_driver.execute(sql, conn1)
        result3, rowcount3 = raw_dbms_driver.execute(sql, conn3)
        result2, rowcount2 = original_dbms_driver.execute(sql, conn2)
        is_error1 = (rowcount1 < 0 and original_dbms_driver.error_check(result1))
        is_error2 = (rowcount2 < 0 and original_dbms_driver.error_check(result2))
        is_error3 = (rowcount3 < 0 and original_dbms_driver.error_check(result3))

        conn1_stable = (is_error1 == is_error2 and result1 == result2)
        if not conn1_stable:
            if is_error1 != is_error2:
                result_q.put((RADAR_ERR1, sql,
                              f"conn1 unstable: one ok one err; r1({rowcount1}): {result1}; r2({rowcount2}): {result2}"))
                return
            if is_error1 and is_error2 and result1[:200] != result2[:200]:
                result_q.put((RADAR_ERR1, sql,
                              f"conn1 unstable error mismatch; r1({rowcount1}): {result1}; r2({rowcount2}): {result2}"))
                return
            result_q.put((SUCCESS_EXEC, sql, result1))
            return

        stable_result = result1
        stable_is_error = is_error1
        stable_rowcount = rowcount1

        if stable_is_error == is_error3 and stable_result == result3:
            if stable_is_error:
                result_q.put((NORMAL_ERR, sql, stable_result))
            else:
                result_q.put((SUCCESS_EXEC, sql, stable_result))
            return

        if stable_is_error!= is_error3:
            result_q.put((RADAR_ERR3, sql,
                          f"error-state mismatch; conn1({stable_rowcount}): {stable_result}; conn3({rowcount3}): {result3}"))
            return
        if stable_is_error and is_error3 and stable_result[:200] != result3[:200]:
            result_q.put((RADAR_ERR2, sql, f"error detail mismatch; conn1: {stable_result}; conn3: {result3}"))
            return
        result_q.put((RADAR_ERR3, sql, f"result mismatch; conn1: {stable_result}; conn3: {result3}"))
    finally:
        conn1.close()
        conn2.close()
        conn3.close()


class FuzzProgram:
    def __init__(self,
                 original_dbms_config_path,
                 raw_dbms_config_path,
                 output_dir,
                 type_convert_mapping_path,
                 sqlcraft_config_path,
                 default_schema_dir,
                 nums,
                 max_nums,
                 max_batches,
                 max_workers,
                 sql_execution_timelimit,
                 sql_generation_timelimit
                 ):
        self.output_dir = output_dir
        self.generated_sql_dir = os.path.join(output_dir, "generated_sql")
        if not os.path.exists(self.generated_sql_dir):
            os.makedirs(self.generated_sql_dir)
        self.schemas_dir = os.path.join(output_dir, "generated_schemas")
        if not os.path.exists(self.schemas_dir):
            os.makedirs(self.schemas_dir)
        self.record_dir = os.path.join(output_dir, "record")
        if not os.path.exists(self.record_dir):
            os.makedirs(self.record_dir)
        self.record = Record(output_dir=self.record_dir)
        self.crash_dir = os.path.join(output_dir, "crash")
        if not os.path.exists(self.crash_dir):
            os.makedirs(self.crash_dir)

        self.error_record = ErrorRecord(output_dir=self.record_dir)
        self.radar_record = RadarRecord(output_dir=self.record_dir)

        self.schema_generator = SchemaGenerator(
            dbms_config_path=original_dbms_config_path,
            output_dir=os.path.join(output_dir, "current_schema"),
            database_name="sqlcraft_radar",
            type_convert_mapping_path=type_convert_mapping_path,
            default_schema_dir=default_schema_dir
        )

        self.sql_generator = SQLGenerator(config_path=sqlcraft_config_path)
        self.sql_generator.run_sqlcraft()

        self.original_dbms_driver = DBMSDriver.get_instance(original_dbms_config_path)
        self.raw_dbms_driver = DBMSDriver.get_instance(raw_dbms_config_path)

        self.nums = nums
        self.max_nums = max_nums
        self.max_batches = max_batches
        self.max_workers = max_workers
        self.sql_execution_timelimit = sql_execution_timelimit
        self.sql_generation_timelimit = sql_generation_timelimit

        self.sql_gen_throughput_count = ThroughputCount()
        self.sql_exec_throughput_count = ThroughputCount()
        self.dashboard = RadarDashboard(self.record, self.sql_gen_throughput_count, self.sql_exec_throughput_count)

    def run(self):
        t = threading.Thread(
            target=self.dashboard.run,
            name="DashboardThread",
            daemon=True
        )
        t.start()
        batch_id = 0
        java_program_retry_cnt = 0
        logging.info("[MASTER] Start Fuzzing ...")
        while True:
            schema_id = str(uuid.uuid4())
            crashed = False
            program_error = False
            generated_sqls_output_path = os.path.join(self.generated_sql_dir, f"batch_{batch_id}.jsonl")
            if os.path.exists(generated_sqls_output_path):
                os.remove(generated_sqls_output_path)
            batch_id = (batch_id + 1) % self.max_batches
            generated_sql_count = 0
            executed_sql_count = 0

            executed_sqls = list()
            executed_error_sqls = list()

            try:
                if not self.original_dbms_driver.restart_server():
                    logging.error(f"Failed to restart {self.original_dbms_driver.get_dbms_name()} before testing next epoch")
                    sys.exit(-1)

                logging.info(f"[MASTER] Ready to generate schema (id: {schema_id}) ...")
                converted_schema_json_path, original_schema_sqls_path, raw_schema_sqls_path = self.schema_generator.generate_schema()
                current_schema_dir = os.path.join(self.schemas_dir, schema_id)
                os.makedirs(current_schema_dir)
                shutil.copy(converted_schema_json_path, os.path.join(current_schema_dir, "converted_schema.json"))
                shutil.copy(original_schema_sqls_path, os.path.join(current_schema_dir, "original_schema.sql"))
                shutil.copy(raw_schema_sqls_path, os.path.join(current_schema_dir, "raw_schema.sql"))
                logging.info(f"[MASTER] Schema generated successfully, saved in: {current_schema_dir}")

                logging.info(f"[MASTER] Ready to initialize DBMS ...")
                try:
                    self.original_dbms_driver.build_schema()
                    self.raw_dbms_driver.build_schema()
                    logging.info("[MASTER] DBMS initialized successfully!")
                except Exception as e:
                    logging.error(f"[MASTER] Failed to initialize DBMS: {e}")
                    crashed = True
                    break

                logging.info(f"[MASTER] Ready to start the worker of sql generator ...")
                self.sql_gen_throughput_count.start()
                generated_sqls = Queue()
                generator_p = Process(target=worker_generate_sqls, args=(self.sql_generator, self.nums, self.max_nums, generated_sqls, generated_sqls_output_path))
                generator_p.start()
                logging.info(f"[MASTER] SQL generator started successfully, output path: {generated_sqls_output_path}")

                logging.info(f"[MASTER] Ready to start the worker of sql execution ...")
                self.sql_exec_throughput_count.start()
                running = {}
                result_q = Queue()
                last_sql_get_time = time.time()

                while generator_p.exitcode is None or not generated_sqls.empty():
                    while not generated_sqls.empty() and len(running) < self.max_workers:
                        sql = generated_sqls.get()
                        generated_sql_count += 1
                        last_sql_get_time = time.time()
                        java_program_retry_cnt = 0
                        if sql[0] == SUCCESS_GEN:
                            executor_p = Process(target=worker_fuzzing, args=(self.original_dbms_driver, self.raw_dbms_driver, sql[1], result_q))
                            executor_p.start()
                            running[executor_p.pid] = (executor_p, time.time(), sql[1])
                            logging.info(f"[THREAD-{executor_p.pid}] Executing SQL: {sql[1]}")
                        else:
                            logging.error(f"[MASTER] Failed to generate SQL: {sql[1]}")
                            program_error = True
                            break
                    self.sql_gen_throughput_count.mark(generated_sql_count)

                    for pid, (executor_p, start, sql) in list(running.items()):
                        if not executor_p.is_alive():
                            executor_p.join()
                            running.pop(pid)
                        elif time.time() - start > self.sql_execution_timelimit:
                            logging.error(f"[THREAD-{pid}] SQL execution timeout, SQL: {sql}, schema_id: {schema_id}")
                            executor_p.kill()
                            result_q.put((TIMEOUT_ERR, sql, f"timeout (limit: {self.sql_execution_timelimit}s)"))
                            running.pop(pid)

                    while not result_q.empty():
                        msg = result_q.get()
                        executed_sql_count += 1
                        executed_sqls.append(msg[1])
                        if msg[0] == CRASH_ERR:
                            logging.error(f"[MASTER] Crashed, SQL: {msg[1]}, error info: {msg[2]}, schema_id: {schema_id}")
                            crashed = True
                            executed_error_sqls.append(msg[1])
                        else:
                            if msg[0] == SUCCESS_EXEC:
                                self.record.increase_total_sql_num()
                            else:
                                self.error_record.record_error(msg[1], msg[2], schema_id)
                                self.record.update1(1, 1, self.error_record.get_error_type_count())
                                executed_error_sqls.append(msg[1])
                            if msg[0] in [RADAR_ERR1, RADAR_ERR2, RADAR_ERR3]:
                                self.radar_record.record(msg[1], msg[2], schema_id)
                                self.record.update4(self.radar_record.radar_num)
                                executed_error_sqls.append(msg[1])
                    self.sql_exec_throughput_count.mark(executed_sql_count)

                    if len(running) == 0 and time.time() - last_sql_get_time > self.sql_generation_timelimit:
                        logging.error(f"SQL generation timeout!")
                        program_error = True

                    if program_error or crashed:
                        generator_p.kill()
                        generator_p.join()
                        for pid, (executor_p, start, sql) in list(running.items()):
                            executor_p.kill()
                            executor_p.join()
                            running.pop(pid)
                        break

            except (JavaProgramError, Exception) as e:
                logging.error(f"Error occurs: {str(e)}")
                sys.exit(-1)
            finally:
                logging.info(f"[MASTER] Dumping static information ...")
                if crashed:
                    self.record.increase_crash_num()
                self.record.mark_end_time()
                self.record.dump()
                self.error_record.dump()
                self.radar_record.dump()
                logging.info(f"[MASTER] Dumping static information done")
                logging.info(f"[MASTER] Current static information: {self.record.to_str()}")

            if crashed:
                crash_dir = os.path.join(self.crash_dir, schema_id)
                os.makedirs(crash_dir, exist_ok=True)
                with open(file=os.path.join(crash_dir, "executed_sqls.txt"), mode="w", encoding="utf-8") as f:
                    f.write("\n".join(executed_sqls))

                with open(file=os.path.join(crash_dir, f"executed_error_sqls.txt"), mode="w", encoding="utf-8") as f:
                    f.write("\n".join(executed_error_sqls))

                shutil.copy(os.path.join(self.schemas_dir, schema_id, "converted_schema.json"),
                            os.path.join(crash_dir, "converted_schema.json"))
                shutil.copy(os.path.join(self.schemas_dir, schema_id, "original_schema.sql"),
                            os.path.join(crash_dir, "original_schema.sql"))
                shutil.copy(os.path.join(self.schemas_dir, schema_id, "raw_schema.sql"),
                            os.path.join(crash_dir, "raw_schema.sql"))

            if program_error:
                if java_program_retry_cnt < 5:
                    logging.info(f"[MASTER] Ready to restart SQLCraft.jar")
                    self.sql_generator.stop_sqlcraft()
                    self.sql_generator.run_sqlcraft()
                    java_program_retry_cnt += 1
                else:
                    logging.error(f"[MASTER] Failed to restart SQLCraft.jar after {java_program_retry_cnt} attempts")
                    sys.exit(-1)



def test_mysql():
    logging_util.setup_logging(r"./data/mysql/radar/logs/fuzz.log")
    FuzzProgram(
        original_dbms_config_path=r"./configs/dbms/radar/original_mysql.yml",
        raw_dbms_config_path=r"./configs/dbms/radar/raw_mysql.yml",
        output_dir=r"./data/mysql/radar/",
        type_convert_mapping_path=r"./configs/dbms/radar/mysql_type_convert_mapping.json",
        sqlcraft_config_path=r"./jar/configs/mysql/radar_config_pve.json",
        default_schema_dir=r"./data/mysql/radar/default_schema/",
        nums=5000,
        max_nums=50000,
        max_batches=10,
        max_workers=2,
        sql_execution_timelimit=60,
        sql_generation_timelimit=60 * 30
    ).run()

def test_tidb():
    logging_util.setup_logging(r"./data/tidb/radar/logs/fuzz.log")
    FuzzProgram(
        original_dbms_config_path=r"./configs/dbms/radar/original_tidb.yml",
        raw_dbms_config_path=r"./configs/dbms/radar/raw_tidb.yml",
        output_dir=r"./data/tidb/radar/",
        type_convert_mapping_path=r"./configs/dbms/radar/tidb_type_convert_mapping.json",
        sqlcraft_config_path=r"./jar/configs/tidb/radar_config_pve.json",
        default_schema_dir=r"./data/tidb/radar/default_schema/",
        nums=1000,
        max_nums=10000,
        max_batches=10,
        max_workers=2,
        sql_execution_timelimit=30,
        sql_generation_timelimit=60 * 5
    ).run()

def test_mariadb():
    logging_util.setup_logging(r"./data/mariadb/radar/logs/fuzz.log")
    FuzzProgram(
        original_dbms_config_path=r"./configs/dbms/radar/original_mariadb.yml",
        raw_dbms_config_path=r"./configs/dbms/radar/raw_mariadb.yml",
        output_dir=r"./data/mariadb/radar/",
        type_convert_mapping_path=r"./configs/dbms/radar/mariadb_type_convert_mapping.json",
        sqlcraft_config_path=r"./jar/configs/mariadb/radar_config_pve.json",
        default_schema_dir=r"./data/mariadb/radar/default_schema/",
        nums=5000,
        max_nums=50000,
        max_batches=10,
        max_workers=2,
        sql_execution_timelimit=60,
        sql_generation_timelimit=60 * 30
    ).run()

def test_sqlite():
    logging_util.setup_logging(r"./data/sqlite/radar/logs/fuzz.log")
    FuzzProgram(
        original_dbms_config_path=r"./configs/dbms/radar/original_sqlite.yml",
        raw_dbms_config_path=r"./configs/dbms/radar/raw_sqlite.yml",
        output_dir=r"./data/sqlite/radar/",
        type_convert_mapping_path=r"./configs/dbms/radar/sqlite_type_convert_mapping.json",
        sqlcraft_config_path=r"./jar/configs/sqlite/radar_config_pve.json",
        default_schema_dir=r"./data/sqlite/radar/default_schema/",
        nums=5000,
        max_nums=50000,
        max_batches=10,
        max_workers=2,
        sql_execution_timelimit=60,
        sql_generation_timelimit=60 * 30
    ).run()

def test_tidb():
    logging_util.setup_logging(r"./data/tidb/radar/logs/fuzz.log")
    FuzzProgram(
        original_dbms_config_path=r"./configs/dbms/radar/original_tidb.yml",
        raw_dbms_config_path=r"./configs/dbms/radar/raw_tidb.yml",
        output_dir=r"./data/tidb/radar/",
        type_convert_mapping_path=r"./configs/dbms/radar/tidb_type_convert_mapping.json",
        sqlcraft_config_path=r"./jar/configs/tidb/radar_config_pve.json",
        default_schema_dir=r"./data/tidb/radar/default_schema/",
        nums=1000,
        max_nums=10000,
        max_batches=10,
        max_workers=2,
        sql_execution_timelimit=30,
        sql_generation_timelimit=60 * 5
    ).run()

def test_mariadb():
    logging_util.setup_logging(r"./data/mariadb/radar/logs/fuzz.log")
    FuzzProgram(
        original_dbms_config_path=r"./configs/dbms/radar/original_mariadb.yml",
        raw_dbms_config_path=r"./configs/dbms/radar/raw_mariadb.yml",
        output_dir=r"./data/mariadb/radar/",
        type_convert_mapping_path=r"./configs/dbms/radar/mariadb_type_convert_mapping.json",
        sqlcraft_config_path=r"./jar/configs/mariadb/radar_config_pve.json",
        default_schema_dir=r"./data/mariadb/radar/default_schema/",
        nums=5000,
        max_nums=50000,
        max_batches=10,
        max_workers=2,
        sql_execution_timelimit=60,
        sql_generation_timelimit=60 * 30
    ).run()

def test_sqlite():
    logging_util.setup_logging(r"./data/sqlite/radar/logs/fuzz.log")
    FuzzProgram(
        original_dbms_config_path=r"./configs/dbms/radar/original_sqlite.yml",
        raw_dbms_config_path=r"./configs/dbms/radar/raw_sqlite.yml",
        output_dir=r"./data/sqlite/radar/",
        type_convert_mapping_path=r"./configs/dbms/radar/sqlite_type_convert_mapping.json",
        sqlcraft_config_path=r"./jar/configs/sqlite/radar_config_pve.json",
        default_schema_dir=r"./data/sqlite/radar/default_schema/",
        nums=5000,
        max_nums=50000,
        max_batches=10,
        max_workers=2,
        sql_execution_timelimit=60,
        sql_generation_timelimit=60 * 30
    ).run()

if __name__ == '__main__':
    # test_mysql()

    test_tidb()

    # test_mariadb()

    # test_sqlite()