import json
import os.path
import subprocess
import sys

import yaml

from dbms_driver import DBMSDriver

SQL_NUMS = 10000
DATA_DIR = "."


def gen_sqls(target_dbms):
    rule_file = f"{DATA_DIR}/dbms/{target_dbms}/function.yy"
    output_prefix = f"{DATA_DIR}/outputs/{target_dbms}/output"
    cmd = ["./go-randgen", "gentest", "-Y", rule_file, "-Q", str(SQL_NUMS), "--output", output_prefix, "--skip-zz", "--maxrecur", "0"]
    subprocess.run(cmd, check=True)
    with open(f"{DATA_DIR}/outputs/{target_dbms}/output.sql", "r", encoding="utf-8") as f:
        sqls = f.read().split("\n")
    return sqls


def run(config_path):
    with open(config_path) as f:
        config = yaml.safe_load(f)
    dbms_driver = DBMSDriver.get_instance(config)
    dbms_driver.build_schema()
    target_dbms = config["target_dbms"]
    generated_sqls = gen_sqls(target_dbms)
    conn = dbms_driver.get_conn()
    error_count = 0
    log_result = []
    running_result = []
    for sql in generated_sqls:
        result, rowcount = dbms_driver.execute(sql, conn)
        if rowcount < -1 and dbms_driver.error_check(result):
            log_result.append(f"Error occurs when executing SQL: {sql}\nError message: {result}")
            error_count += 1
            running_result.append({
                "sql": sql,
                "result": "error",
                "error_info": result
            })
        else:
            running_result.append({
                "sql": sql,
                "result": "success",
                "error_info": ""
            })
    log_result.append(f"Acc rate: {(len(generated_sqls) - error_count) / len(generated_sqls)}")
    running_result_path = os.path.join(DATA_DIR, "outputs", target_dbms, "running_result.jsonl")
    if os.path.exists(running_result_path):
        os.remove(running_result_path)
    with open(file=running_result_path, mode="a", encoding="utf-8") as f:
        for item in running_result:
            f.write(json.dumps(item) + "\n")
    return log_result


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description="Run accuracy test for a target DBMS")
    parser.add_argument("config", help="Path to the DBMS config YAML file (e.g. configs/sqlite.yaml)")
    args = parser.parse_args()
    result = run(args.config)
    output = "\n".join(result)
    sys.stdout.buffer.write(output.encode("utf-8"))
    sys.stdout.buffer.write(b"\n")
