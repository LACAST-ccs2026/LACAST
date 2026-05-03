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
# from normal_sql_generator import SQLGenerator
from new_sql_generator import SQLGenerator
from record import Record, ErrorRecord, ThroughputCount
from schema_generator import SchemaGenerator

NORMAL_ERR = "err"
SUCCESS_EXEC = "ok"
TIMEOUT_ERR = "timeout"
CRASH_ERR = "crash"

SUCCESS_GEN = "ok"
ERR_GEN = "err_gen"

NFS_MOUNT_DIR = "./nfs_data"

def worker_generate_sqls(sql_generator: SQLGenerator, nums: int, max_nums: int, result_q: Queue, output_path: str):
    _count = 0
    while _count < max_nums:
        try:
            # result = sql_generator.call_sqlcraft(f"learnR: query 0 {nums}")
            result = sql_generator.call_sqlcraft(f"test: query 0 {nums}")
            _count += len(result)
            with open(file=output_path, mode="a", encoding="utf-8") as f:
                for sql in result:
                    f.write(f"{sql}\n")
                    result_q.put((SUCCESS_GEN, sql))
        except Exception as e:
            result_q.put((ERR_GEN, str(e)))


def worker_fuzzing(dbms_driver: DBMSDriver, sql: str, result_q: Queue):
    conn = None
    try:
        conn = dbms_driver.get_conn()

    except Exception as e:
        if conn:
            conn.close()
        result_q.put((CRASH_ERR, sql, str(e)))
        return
    try:
        result, rowcount = dbms_driver.execute(sql, conn)
        if rowcount < -1 and dbms_driver.error_check(result):
            result_q.put((NORMAL_ERR, sql, result))
        else:
            result_q.put((SUCCESS_EXEC, sql, result))
    finally:
        conn.close()


class FuzzProgram:
    def __init__(self,
                 dbms_config_path,
                 output_dir,
                 type_convert_mapping_path,
                 sqlcraft_config_path,
                 default_schema_dir,
                 nums,
                 max_nums,
                 # max_batches,
                 sqls_record_time_step,
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
        self.schema_generator = SchemaGenerator(
            dbms_config_path=dbms_config_path,
            output_dir=os.path.join(output_dir, "current_schema"),
            database_name="sqlcraft",
            type_convert_mapping_path=type_convert_mapping_path,
            default_schema_dir=default_schema_dir
        )

        self.sql_generator = SQLGenerator(config_path=sqlcraft_config_path)
        self.sql_generator.run_sqlcraft()

        self.dbms_driver = DBMSDriver.get_instance(dbms_config_path)
        self.nums = nums
        self.max_nums = max_nums
        self.sqls_record_time_step = sqls_record_time_step
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
        # batch_id = 0
        # start_time = time.time()
        # time_str = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(start_time))
        # generated_sqls_output_path = os.path.join(self.generated_sql_dir, f"{time_str}.txt")
        start_time = time.time()
        time_str = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(start_time))
        generated_sqls_tmp_dir = os.path.join(self.generated_sql_dir, time_str)
        os.makedirs(generated_sqls_tmp_dir)
        java_program_retry_cnt = 0
        logging.info("[MASTER] Start Fuzzing ...")
        while True:
            schema_id = str(uuid.uuid4())
            crashed = False
            program_error = False
            # generated_sqls_output_path = os.path.join(self.generated_sql_dir, f"batch_{batch_id}.jsonl")
            # if os.path.exists(generated_sqls_output_path):
            #     os.remove(generated_sqls_output_path)
            # batch_id = (batch_id + 1) % self.max_batches

            # if time.time() - start_time >= self.sqls_record_time_step * 60:
            #     start_time = time.time()
            #     time_str = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(start_time))
            #     generated_sqls_output_path = os.path.join(self.generated_sql_dir, f"{time_str}.txt")

            if time.time() - start_time >= self.sqls_record_time_step * 60:
                shutil.move(generated_sqls_tmp_dir, os.path.join(NFS_MOUNT_DIR, self.dbms_driver.get_dbms_name()))
                # shutil.copytree(generated_sqls_tmp_dir, os.path.join(NFS_MOUNT_DIR, self.dbms_driver.get_dbms_name(), os.path.basename(generated_sqls_tmp_dir)), dirs_exist_ok=True)
                start_time = time.time()
                time_str = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(start_time))
                generated_sqls_tmp_dir = os.path.join(self.generated_sql_dir, time_str)
                os.makedirs(generated_sqls_tmp_dir)

            generated_schema_tmp_dir = os.path.join(generated_sqls_tmp_dir, schema_id)
            os.makedirs(generated_schema_tmp_dir)
            generated_sqls_output_path = os.path.join(generated_schema_tmp_dir, f"{time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))}.txt")

            generated_sql_count = 0
            executed_sql_count = 0

            executed_sqls = list()
            executed_error_sqls = list()

            try:
                if not self.dbms_driver.restart_server():
                    logging.error(f"Failed to restart {self.dbms_driver.get_dbms_name()} before testing next epoch")
                    sys.exit(-1)

                logging.info(f"[MASTER] Ready to generate schema (id: {schema_id}) ...")
                converted_schema_json_path, schema_sqls_path = self.schema_generator.generate_single_schema()
                current_schema_dir = os.path.join(self.schemas_dir, schema_id)
                os.makedirs(current_schema_dir)
                shutil.copy(converted_schema_json_path, os.path.join(current_schema_dir, "converted_schema.json"))
                shutil.copy(schema_sqls_path, os.path.join(current_schema_dir, "schema.sql"))
                shutil.copy(converted_schema_json_path, os.path.join(generated_schema_tmp_dir, "converted_schema.json"))
                shutil.copy(schema_sqls_path, os.path.join(generated_schema_tmp_dir, "schema.sql"))
                logging.info(f"[MASTER] Schema generated successfully, saved in: {current_schema_dir}")

                logging.info(f"[MASTER] Ready to initialize DBMS ...")
                try:
                    self.dbms_driver.build_schema()
                    logging.info("[MASTER] DBMS initialized successfully!")
                except Exception as e:
                    logging.error(f"[MASTER] Failed to initialize DBMS: {e}")
                    # crashed = True
                    # break
                    logging.info(f"[MASTER] Remove schema dir: {current_schema_dir}")
                    shutil.rmtree(current_schema_dir)
                    time.sleep(10)
                    continue

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

                while generator_p.exitcode is None or not generated_sqls.empty() or len(running) > 0:
                    while not generated_sqls.empty() and len(running) < self.max_workers:
                        sql = generated_sqls.get()
                        generated_sql_count += 1
                        last_sql_get_time = time.time()
                        java_program_retry_cnt = 0
                        if sql[0] == SUCCESS_GEN:
                            executor_p = Process(target=worker_fuzzing, args=(self.dbms_driver, sql[1], result_q))
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
                shutil.copy(os.path.join(self.schemas_dir, schema_id, "schema.sql"),
                            os.path.join(crash_dir, "schema.sql"))

                if not self.dbms_driver.restart_server():
                    logging.error(f"Failed to restart {self.dbms_driver.get_dbms_name()} after crash")
                    sys.exit(-1)

            if program_error:
                if java_program_retry_cnt < 5:
                    logging.info(f"[MASTER] Ready to restart SQLCraft.jar")
                    self.sql_generator.stop_sqlcraft()
                    self.sql_generator.run_sqlcraft()
                    java_program_retry_cnt += 1
                else:
                    logging.error(f"[MASTER] Failed to restart SQLCraft.jar after {java_program_retry_cnt} attempts")
                    sys.exit(-1)


def test_sqlite():
    pid_file = r"./data/sqlite/normal/normal_fuzz2.pid"

    print(f"PID file path: {pid_file}")

    os.makedirs(os.path.dirname(pid_file), exist_ok=True)
    with open(pid_file, "w") as f:
        f.write(str(os.getpid()))

    logging_util.setup_logging(r"./data/sqlite/normal/logs/fuzz.log")

    FuzzProgram(
        dbms_config_path=r"./configs/dbms/normal/sqlite.yml",
        output_dir=r"./data/sqlite/normal/",
        type_convert_mapping_path=r"./configs/dbms/normal/sqlite_type_convert_mapping.json",
        sqlcraft_config_path=r"./jar/configs/sqlite/normal_configs_pve.json",
        default_schema_dir=r"./data/sqlite/normal/default_schema/",
        nums=10,
        max_nums=100,
        sqls_record_time_step=60,
        max_workers=8,
        sql_execution_timelimit=30,
        sql_generation_timelimit=60 * 5
    ).run()

    if os.path.exists(pid_file):
        os.remove(pid_file)

def test_mariadb():
    pid_file = r"./data/mariadb/normal/normal_fuzz2.pid"

    print(f"PID file path: {pid_file}")

    os.makedirs(os.path.dirname(pid_file), exist_ok=True)
    with open(pid_file, "w") as f:
        f.write(str(os.getpid()))

    logging_util.setup_logging(r"./data/mariadb/normal/logs/fuzz.log")

    FuzzProgram(
        dbms_config_path=r"./configs/dbms/normal/mariadb.yml",
        output_dir=r"./data/mariadb/normal/",
        type_convert_mapping_path=r"./configs/dbms/normal/mariadb_type_convert_mapping.json",
        sqlcraft_config_path=r"./jar/configs/mariadb/normal_configs_pve.json",
        default_schema_dir=r"./data/mariadb/normal/default_schema/",
        nums=100,
        max_nums=10,
        sqls_record_time_step=60,
        max_workers=8,
        sql_execution_timelimit=30,
        sql_generation_timelimit=60 * 5
    ).run()

    if os.path.exists(pid_file):
        os.remove(pid_file)

def test_mysql():
    pid_file = r"./data/mysql/normal/normal_fuzz2.pid"

    print(f"PID file path: {pid_file}")

    os.makedirs(os.path.dirname(pid_file), exist_ok=True)
    with open(pid_file, "w") as f:
        f.write(str(os.getpid()))

    logging_util.setup_logging(r"./data/mysql/normal/logs/fuzz.log")

    FuzzProgram(
        dbms_config_path=r"./configs/dbms/normal/mysql.yml",
        output_dir=r"./data/mysql/normal/",
        type_convert_mapping_path=r"./configs/dbms/normal/mysql_type_convert_mapping.json",
        sqlcraft_config_path=r"./jar/configs/mysql/normal_configs_pve.json",
        default_schema_dir=r"./data/mysql/normal/default_schema/",
        nums=10,
        max_nums=100,
        sqls_record_time_step=60,
        max_workers=8,
        sql_execution_timelimit=30,
        sql_generation_timelimit=60 * 5
    ).run()

    if os.path.exists(pid_file):
        os.remove(pid_file)

def test_postgres():
    pid_file = r"./data/postgres/normal/normal_fuzz2.pid"

    print(f"PID file path: {pid_file}")

    os.makedirs(os.path.dirname(pid_file), exist_ok=True)
    with open(pid_file, "w") as f:
        f.write(str(os.getpid()))

    logging_util.setup_logging(r"./data/postgres/normal/logs/fuzz.log")

    FuzzProgram(
        dbms_config_path=r"./configs/dbms/normal/postgres.yml",
        output_dir=r"./data/postgres/normal/",
        type_convert_mapping_path=r"./configs/dbms/normal/postgres_type_convert_mapping.json",
        sqlcraft_config_path=r"./jar/configs/postgres/normal_configs_pve.json",
        default_schema_dir=r"./data/postgres/normal/default_schema/",
        nums=10,
        max_nums=100,
        sqls_record_time_step=60,
        max_workers=8,
        sql_execution_timelimit=30,
        sql_generation_timelimit=60 * 5
    ).run()

    if os.path.exists(pid_file):
        os.remove(pid_file)

def test_tidb():
    pid_file = r"./data/tidb/normal/normal_fuzz2.pid"

    print(f"PID file path: {pid_file}")

    os.makedirs(os.path.dirname(pid_file), exist_ok=True)
    with open(pid_file, "w") as f:
        f.write(str(os.getpid()))

    logging_util.setup_logging(r"./data/tidb/normal/logs/fuzz.log")

    FuzzProgram(
        dbms_config_path=r"./configs/dbms/normal/tidb.yml",
        output_dir=r"./data/tidb/normal/",
        type_convert_mapping_path=r"./configs/dbms/normal/tidb_type_convert_mapping.json",
        sqlcraft_config_path=r"./jar/configs/tidb/normal_configs_pve.json",
        default_schema_dir=r"./data/tidb/normal/default_schema/",
        nums=10,
        max_nums=100,
        sqls_record_time_step=60,
        max_workers=8,
        sql_execution_timelimit=30,
        sql_generation_timelimit=60 * 5
    ).run()

    if os.path.exists(pid_file):
        os.remove(pid_file)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python normal_fuzz2.py <db_name>")
        print("Available db names: sqlite, mariadb, mysql, postgres, tidb")
        sys.exit(1)
    
    db_name = sys.argv[1].lower()
    db_functions = {
        "sqlite": test_sqlite,
        "mariadb": test_mariadb,
        "mysql": test_mysql,
        "postgres": test_postgres,
        "tidb": test_tidb
    }
    
    if db_name not in db_functions:
        print(f"Unknown db: {db_name}")
        print("Available db names: sqlite, mariadb, mysql, postgres, tidb")
        sys.exit(1)
    
    db_functions[db_name]()
