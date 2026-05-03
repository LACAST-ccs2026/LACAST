import json
import logging
import os
import shutil
import signal
import subprocess
import sys

import yaml

from custom_error import JavaProgramError

RADAR_JAR_PATH = r"./jar/sqlancer-2.0.0.jar"
SINGLE_SCHEMA_GENERATOR_JAR_PATH = r"./jar/schema-generator.jar"


class SchemaGenerator:
    def __init__(self, dbms_config_path, output_dir, database_name, type_convert_mapping_path, default_schema_dir):
        self.dbms_config_path = dbms_config_path
        with open(dbms_config_path, "r") as f:
            self.dbms_config = yaml.safe_load(f)
        self.output_dir = output_dir
        self.database_name = database_name
        self.type_convert_mapping_path = type_convert_mapping_path
        with open(file=type_convert_mapping_path, mode="r", encoding="utf-8") as f:
            self.type_convert_mapping = json.load(f)
        self.default_converted_schema_json_path = os.path.join(default_schema_dir, "converted_schema.json")
        self.default_original_schema_sql_path = os.path.join(default_schema_dir, "original_schema.sql")
        self.default_raw_schema_sql_path = os.path.join(default_schema_dir, "raw_schema.sql")

    def error_exit(self, error_info):
        logging.error(error_info)
        os.kill(os.getpid(), signal.SIGINT)
        sys.exit(1)

    def type_convert(self):
        schema_path = os.path.join(self.output_dir, "schema.json")
        with open(file=schema_path, mode="r", encoding="utf-8") as f:
            schema = json.load(f)
        converted_schema = [{
            "key": table_info["key"],
            "fields": table_info["fields"],
            "types": [self.type_convert_mapping[field_type] for field_type in table_info["types"]]
        } for table_info in schema]
        converted_schema_path = os.path.join(self.output_dir, "converted_schema.json")
        with open(converted_schema_path, "w", encoding="utf-8") as f:
            json.dump(converted_schema, f, indent=4, ensure_ascii=False)

    def generate_schema(self):
        try:
            jar_command = ["java", "-jar", RADAR_JAR_PATH,
                           "--print-failed", "false",
                           "--output-dir", self.output_dir,
                           "--database-prefix", self.database_name]
            if self.dbms_config["target_dbms"] == "sqlite":
                jar_command.extend(["sqlite3"])
            elif self.dbms_config["target_dbms"] == "mysql":
                jar_command.extend(["--host", self.dbms_config["db_config"]["host"],
                                    "--port", self.dbms_config["db_config"]["port"],
                                    "--username", self.dbms_config["db_config"]["username"],
                                    "--password", self.dbms_config["db_config"]["password"],
                                    "mysql"])
            elif self.dbms_config["target_dbms"] == "tidb":
                jar_command.extend(["--host", self.dbms_config["db_config"]["host"],
                                    "--port", self.dbms_config["db_config"]["port"],
                                    "--username", self.dbms_config["db_config"]["username"],
                                    "--password", self.dbms_config["db_config"]["password"],
                                    "tidb"])
            elif self.dbms_config["target_dbms"] == "mariadb":
                jar_command.extend(["--host", self.dbms_config["db_config"]["host"],
                                    "--port", self.dbms_config["db_config"]["port"],
                                    "--username", self.dbms_config["db_config"]["username"],
                                    "--password", self.dbms_config["db_config"]["password"],
                                    "mariadb"])
            else:
                self.error_exit(f"Radar({RADAR_JAR_PATH}) don't support {self.dbms_config['target_dbms']}")
            raw_result = subprocess.run(
                jar_command,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )
            if raw_result.returncode != 0:
                raise JavaProgramError(raw_result.stderr)

            schema_json_path = os.path.join(self.output_dir, "schema.json")
            if not os.path.exists(schema_json_path):
                # self.error_exit(f"Radar({RADAR_JAR_PATH}) don't generate schema.json")
                raise Exception(f"Radar({RADAR_JAR_PATH}) don't generate schema.json")
            statements_txt_path = os.path.join(self.output_dir, "statements.txt")
            if not os.path.exists(statements_txt_path):
                # self.error_exit(f"Radar({RADAR_JAR_PATH}) don't generate statements.txt")
                raise Exception(f"Radar({RADAR_JAR_PATH}) don't generate statements.txt")

            with open(file=statements_txt_path, mode="r") as f:
                statements_txt = f.read()
            statements_txt_split = statements_txt.split("========Create RawDB========;\n")
            original_schema_sqls = statements_txt_split[0]
            raw_schema_sqls = statements_txt_split[1].replace("========Finish Create========;", "")

            original_schema_sqls_path = os.path.join(self.output_dir, "original_schema.sql")
            with open(original_schema_sqls_path, "w") as f:
                f.write(original_schema_sqls)

            raw_schema_sqls_path = os.path.join(self.output_dir, "raw_schema.sql")
            with open(raw_schema_sqls_path, "w") as f:
                f.write(raw_schema_sqls)

            self.type_convert()
            converted_schema_json_path = os.path.join(self.output_dir, "converted_schema.json")

            return converted_schema_json_path, original_schema_sqls_path, raw_schema_sqls_path

        except JavaProgramError as e:
            return self.generate_schema()

        except Exception as e:
            logging.error(f"Error occurs when generating schema using Radar({RADAR_JAR_PATH}): {e}")
            # raise e
            logging.info(f"Using default schema configuration...")
            shutil.copyfile(self.default_converted_schema_json_path, os.path.join(self.output_dir, "converted_schema.json"))
            shutil.copyfile(self.default_original_schema_sql_path, os.path.join(self.output_dir, "original_schema.sql"))
            shutil.copyfile(self.default_raw_schema_sql_path, os.path.join(self.output_dir, "raw_schema.sql"))
            return os.path.join(self.output_dir, "converted_schema.json"), os.path.join(self.output_dir, "original_schema.sql"), os.path.join(self.output_dir, "raw_schema.sql")
            # os.kill(os.getpid(), signal.SIGINT)
            # sys.exit(1)


    def generate_single_schema(self):
        try:
            if self.dbms_config["target_dbms"] == "postgres":
                jar_command = ["java", "-jar", SINGLE_SCHEMA_GENERATOR_JAR_PATH,
                               "--output-dir", self.output_dir,
                               "--num-tables", "10",
                               "--max-columns", "20",
                               "--max-rows", "30",
                               "--host", self.dbms_config["db_config"]["host"],
                               "--port", self.dbms_config["db_config"]["port"],
                               "--username", self.dbms_config["db_config"]["username"],
                               "--password", self.dbms_config["db_config"]["password"],
                               "postgres"]
            else:
                jar_command = ["java", "-jar", RADAR_JAR_PATH,
                               "--print-failed", "false",
                               "--single-schema", "true",
                               "--output-dir", self.output_dir,
                               "--database-prefix", self.database_name]
                if self.dbms_config["target_dbms"] == "sqlite":
                    jar_command.extend(["sqlite3"])
                elif self.dbms_config["target_dbms"] == "mysql":
                    jar_command.extend(["--host", self.dbms_config["db_config"]["host"],
                                        "--port", self.dbms_config["db_config"]["port"],
                                        "--username", self.dbms_config["db_config"]["username"],
                                        "--password", self.dbms_config["db_config"]["password"],
                                        "mysql"])
                elif self.dbms_config["target_dbms"] == "tidb":
                    jar_command.extend(["--host", self.dbms_config["db_config"]["host"],
                                        "--port", self.dbms_config["db_config"]["port"],
                                        "--username", self.dbms_config["db_config"]["username"],
                                        "--password", self.dbms_config["db_config"]["password"],
                                        "tidb"])
                elif self.dbms_config["target_dbms"] == "mariadb":
                    jar_command.extend(["--host", self.dbms_config["db_config"]["host"],
                                        "--port", self.dbms_config["db_config"]["port"],
                                        "--username", self.dbms_config["db_config"]["username"],
                                        "--password", self.dbms_config["db_config"]["password"],
                                        "mariadb"])
                else:
                    self.error_exit(f"Radar({RADAR_JAR_PATH}) don't support {self.dbms_config['target_dbms']}")

            raw_result = subprocess.run(
                jar_command,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )
            if raw_result.returncode != 0:
                raise JavaProgramError(raw_result.stderr)

            schema_json_path = os.path.join(self.output_dir, "schema.json")
            if not os.path.exists(schema_json_path):
                # self.error_exit(f"Radar({RADAR_JAR_PATH}) don't generate schema.json")
                raise Exception(f"Radar({RADAR_JAR_PATH}) don't generate schema.json")
            statements_txt_path = os.path.join(self.output_dir, "statements.txt")
            if not os.path.exists(statements_txt_path):
                # self.error_exit(f"Radar({RADAR_JAR_PATH}) don't generate statements.txt")
                raise Exception(f"Radar({RADAR_JAR_PATH}) don't generate statements.txt")

            with open(file=statements_txt_path, mode="r") as f:
                statements_txt = f.read()

            schema_sqls_path = os.path.join(self.output_dir, "schema.sql")
            with open(schema_sqls_path, "w") as f:
                f.write(statements_txt)

            self.type_convert()
            converted_schema_json_path = os.path.join(self.output_dir, "converted_schema.json")

            return converted_schema_json_path, schema_sqls_path

        except JavaProgramError as e:
            return self.generate_single_schema()

        except Exception as e:
            logging.error(f"Error occurs when generating schema using Radar({RADAR_JAR_PATH}): {e}")
            logging.info(f"Using default schema configuration...")
            shutil.copyfile(self.default_converted_schema_json_path, os.path.join(self.output_dir, "converted_schema.json"))
            shutil.copyfile(self.default_original_schema_sql_path, os.path.join(self.output_dir, "schema.sql"))
            return os.path.join(self.output_dir, "converted_schema.json"), os.path.join(self.output_dir, "schema.sql")
            # os.kill(os.getpid(), signal.SIGINT)
            # sys.exit(1)

if __name__ == '__main__':
    schema_generator = SchemaGenerator(dbms_config_path=r"./configs/dbms/normal/tidb.yml",
                    output_dir=r"./data/tidb/normal/current_schema",
                    database_name="sqlcraft",
                    type_convert_mapping_path=r"./configs/dbms/normal/tidb_type_convert_mapping.json",
                    default_schema_dir=r"./data/tidb/normal/default_schema")
    schema_generator.generate_single_schema()