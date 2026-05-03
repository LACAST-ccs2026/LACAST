import os.path
import sqlite3
from abc import abstractmethod
from collections import Counter
from typing import Any, Tuple

import psycopg2
import yaml
import mysql.connector


class DBMSDriver:
    def __init__(self, **dbms_config):
        self.database_name = dbms_config["database_name"]
        self.schema_path = dbms_config["schema_path"]
        self.db_config = dbms_config["db_config"]
        self.pool = None

    @staticmethod
    def get_instance(target_dbms):
        dbms_config_path = os.path.join("dbms", f"{target_dbms}.yaml")
        with open(file=dbms_config_path, mode="r", encoding="utf-8") as f:
            dbms_config = yaml.safe_load(f)
        target_dbms = dbms_config["target_dbms"]
        if target_dbms == "mysql":
            return MySQLDriver(**dbms_config)
        if target_dbms == "tidb":
            return TiDBDriver(**dbms_config)
        if target_dbms == "postgres":
            return PostgreSQLDriver(**dbms_config)
        if target_dbms == "sqlite":
            return SQLiteDriver(**dbms_config)
        if target_dbms == "mariadb":
            return MariaDBDriver(**dbms_config)
        else:
            raise ValueError(f"{target_dbms} is not supported")

    @abstractmethod
    def build_schema(self) -> None:
        pass

    @abstractmethod
    def get_conn(self) -> Any:
        pass

    @abstractmethod
    def execute(self, sql: str, conn: Any) -> Tuple[str | None, int]:
        pass

    @abstractmethod
    def error_check(self, error_info: str) -> bool:
        pass

    @abstractmethod
    def normalize_result(self, result: Any) -> str | None:
        pass


class MySQLDriver(DBMSDriver):
    def __init__(self, **dbms_config):
        super().__init__(**dbms_config)
        self.host = self.db_config["host"]
        self.port = self.db_config["port"]
        self.username = self.db_config["username"]
        self.password = self.db_config["password"]

    def build_schema(self):
        with mysql.connector.connect(
            host=self.db_config["host"],
            port=self.db_config["port"],
            user=self.db_config["username"],
            password=self.db_config["password"],
            database="mysql",
            autocommit=True,
        ) as con:
            with con.cursor() as cur:
                cur.execute(f"DROP DATABASE IF EXISTS `{self.database_name}`;")
                cur.execute(f"CREATE DATABASE `{self.database_name}`;")

        with mysql.connector.connect(
            host=self.db_config["host"],
            port=self.db_config["port"],
            user=self.db_config["username"],
            password=self.db_config["password"],
            database=self.database_name,
            autocommit=True,
        ) as con:
            with con.cursor() as cur:
                with open(file=self.schema_path, mode="r", encoding="utf-8") as f:
                    sql_file = f.read()
                sql_commands = sql_file.split(";")
                for command in sql_commands:
                    command = command.strip()
                    if command:
                        if command in ["SET SESSION big_tables = ON;"]:
                            continue
                        cur.execute(command)
                        result = cur.fetchall()

    def get_conn(self):
        return mysql.connector.connect(
            host=self.db_config["host"],
            port=self.db_config["port"],
            user=self.db_config["username"],
            password=self.db_config["password"],
            database=self.database_name,
            autocommit=True,
        )

    def execute(self, sql, conn):
        with conn.cursor() as cur:
            try:
                cur.execute(sql)
                result = cur.fetchall()
                rowcount = cur.rowcount
                while cur.nextset():
                    pass
                return self.normalize_result(result), rowcount
            except mysql.connector.Error as e:
                cur.fetchall()
                return str(e), -100

    def error_check(self, error_info):
        return True

    def normalize_result(self, result):
        if result is None:
            return None
        counter = Counter()
        for row in result:
            norm_row = []
            for v in row:
                if v is None:
                    norm_row.append(None)
                    continue
                if isinstance(v, float):
                    norm_row.append(round(v, 6))
                    continue
                if isinstance(v, (bytes, bytearray)):
                    norm_row.append(bytes(v))
                    continue
                norm_row.append(v)
            counter[tuple(norm_row)] += 1
        return str(counter)


class TiDBDriver(DBMSDriver):
    def __init__(self, **dbms_config):
        super().__init__(**dbms_config)
        self.host = self.db_config["host"]
        self.port = self.db_config["port"]
        self.username = self.db_config["username"]
        self.password = self.db_config["password"]

    def build_schema(self):
        with mysql.connector.connect(
            host=self.host,
            port=self.port,
            user=self.username,
            password=self.password,
            database="mysql",
            autocommit=True,
        ) as con:
            with con.cursor() as cur:
                cur.execute(f"DROP DATABASE IF EXISTS `{self.database_name}`;")
                cur.execute(f"CREATE DATABASE `{self.database_name}`;")

        with mysql.connector.connect(
            host=self.host,
            port=self.port,
            user=self.username,
            password=self.password,
            database=self.database_name,
            autocommit=True,
        ) as con:
            with con.cursor() as cur:
                with open(self.schema_path, "r", encoding="utf-8") as f:
                    sql_file = f.read()

                sql_commands = [
                    s.strip() + ";" for s in sql_file.split(";") if s.strip()
                ]

                for cmd in sql_commands:
                    if cmd.upper().startswith("SET "):
                        continue
                    try:
                        cur.execute(cmd)
                        try:
                            cur.fetchall()
                        except Exception:
                            pass
                    except mysql.connector.Error as e:
                        print("TiDB Schema Error:", e)
                        continue

    def get_conn(self):
        conn = mysql.connector.connect(
            host=self.host,
            port=self.port,
            user=self.username,
            password=self.password,
            database=self.database_name,
            autocommit=True,
        )
        with conn.cursor() as cur:
            cur.execute(
                "SET GLOBAL sql_mode = (SELECT REPLACE(@@GLOBAL.sql_mode, 'ONLY_FULL_GROUP_BY', ''));"
            )
            cur.execute(
                "SET SESSION sql_mode = (SELECT REPLACE(@@SESSION.sql_mode, 'ONLY_FULL_GROUP_BY', ''));"
            )
        return conn

    def execute(self, sql, conn):
        with conn.cursor() as cur:
            try:
                cur.execute(sql)
                try:
                    result = cur.fetchall()
                except mysql.connector.InterfaceError:
                    result = []

                rowcount = cur.rowcount
                return self.normalize_result(result), rowcount

            except mysql.connector.Error as e:
                return str(e), -100
            except Exception as e:
                return str(e), -200

    def error_check(self, error_info):
        if "baseBuiltinFunc.vecEvalString()" in error_info:
            return False
        if "baseBuiltinFunc.evalString()" in error_info:
            return False
        if "baseBuiltinFunc.vecEvalInt()" in error_info:
            return False
        if "Unknown column" in error_info:
            return False
        if "Incorrect string value" in error_info:
            return False
        if "value is out of range in" in error_info:
            return False
        if "incorrect time value" in error_info:
            return False
        if "Cannot convert string" in error_info:
            return False
        return True

    def normalize_result(self, result):
        if result is None:
            return None

        counter = Counter()
        for row in result:
            norm_row = []
            for v in row:
                if v is None:
                    norm_row.append(None)
                elif isinstance(v, float):
                    norm_row.append(round(v, 6))
                elif isinstance(v, (bytes, bytearray)):
                    norm_row.append(bytes(v))
                else:
                    norm_row.append(v)
            counter[tuple(norm_row)] += 1

        return str(counter)


class PostgreSQLDriver(DBMSDriver):
    def __init__(self, **dbms_config):
        super().__init__(**dbms_config)
        self.host = self.db_config["host"]
        self.port = self.db_config.get("port", 5432)
        self.username = self.db_config["username"]
        self.password = self.db_config["password"]

    def build_schema(self):
        conn = psycopg2.connect(
            host=self.host,
            port=self.port,
            user=self.username,
            password=self.password,
            database="postgres",
        )

        conn.autocommit = True
        with conn.cursor() as cur:
            cur.execute(f'DROP DATABASE IF EXISTS "{self.database_name}";')
            cur.execute(f'CREATE DATABASE "{self.database_name}";')

        conn.close()

        conn = psycopg2.connect(
            host=self.host,
            port=self.port,
            user=self.username,
            password=self.password,
            database=self.database_name,
        )

        with conn.cursor() as cur:
            with open(self.schema_path, "r", encoding="utf-8") as f:
                sql_file = f.read()

            sql_commands = sql_file.split(";")

            for cmd in sql_commands:
                cmd = cmd.strip()
                if not cmd:
                    continue
                try:
                    cur.execute(cmd)
                except Exception as e:
                    print("Postgres Schema Error:", e)

        conn.commit()
        conn.close()

    def get_conn(self):
        return psycopg2.connect(
            host=self.host,
            port=self.port,
            user=self.username,
            password=self.password,
            database=self.database_name,
        )

    def execute(self, sql, conn):
        with conn.cursor() as cur:
            try:
                cur.execute(sql)

                if cur.description is not None:
                    result = cur.fetchall()
                else:
                    result = []

                rowcount = cur.rowcount
                conn.commit()

                return self.normalize_result(result), rowcount

            except psycopg2.Error as e:
                conn.rollback()
                return str(e), -100
            except Exception as e:
                conn.rollback()
                return str(e), -200

    def error_check(self, error_info):
        return True

    def normalize_result(self, result):
        if result is None:
            return None

        counter = Counter()

        for row in result:
            norm_row = []

            for v in row:
                if v is None:
                    norm_row.append(None)

                elif isinstance(v, float):
                    norm_row.append(round(v, 6))

                elif isinstance(v, memoryview):
                    norm_row.append(bytes(v))

                elif isinstance(v, (bytes, bytearray)):
                    norm_row.append(bytes(v))

                else:
                    norm_row.append(v)

            counter[tuple(norm_row)] += 1

        return str(counter)


class SQLiteDriver(DBMSDriver):
    def __init__(self, **dbms_config):
        super().__init__(**dbms_config)
        self.db_path = self.db_config["db_path"]

    def build_schema(self):
        if os.path.exists(self.db_path):
            os.remove(self.db_path)

        conn = sqlite3.connect(self.db_path)
        with conn:
            with open(self.schema_path, "r", encoding="utf-8") as f:
                sql_text = f.read()

            conn.executescript(sql_text)

        conn.close()

    def get_conn(self):
        return sqlite3.connect(self.db_path)

    def execute(self, sql, conn):
        cursor = conn.cursor()
        try:
            cursor.execute(sql)

            if cursor.description is not None:
                result = cursor.fetchall()
            else:
                result = []

            rowcount = cursor.rowcount
            conn.commit()

            return self.normalize_result(result), rowcount

        except sqlite3.Error as e:
            conn.rollback()
            return str(e), -100

        except Exception as e:
            conn.rollback()
            return str(e), -200

        finally:
            cursor.close()

    def error_check(self, error_info):
        return True

    def normalize_result(self, result):
        if result is None:
            return None

        counter = Counter()

        for row in result:
            norm_row = []

            for v in row:
                if v is None:
                    norm_row.append(None)

                elif isinstance(v, float):
                    norm_row.append(round(v, 6))

                elif isinstance(v, (bytes, bytearray)):
                    norm_row.append(bytes(v))

                else:
                    norm_row.append(v)

            counter[tuple(norm_row)] += 1

        return str(counter)


class MariaDBDriver(DBMSDriver):
    def __init__(self, **dbms_config):
        super().__init__(**dbms_config)
        self.host = self.db_config["host"]
        self.port = self.db_config["port"]
        self.username = self.db_config["username"]
        self.password = self.db_config["password"]

    def build_schema(self):
        with mysql.connector.connect(
            host=self.db_config["host"],
            port=self.db_config["port"],
            user=self.db_config["username"],
            password=self.db_config["password"],
            database="mysql",
            autocommit=True,
        ) as con:
            with con.cursor() as cur:
                cur.execute(f"DROP DATABASE IF EXISTS `{self.database_name}`;")
                cur.execute(f"CREATE DATABASE `{self.database_name}`;")

        with mysql.connector.connect(
            host=self.db_config["host"],
            port=self.db_config["port"],
            user=self.db_config["username"],
            password=self.db_config["password"],
            database=self.database_name,
            autocommit=True,
        ) as con:
            with con.cursor() as cur:
                with open(file=self.schema_path, mode="r", encoding="utf-8") as f:
                    sql_file = f.read()
                sql_commands = sql_file.split(";")
                for command in sql_commands:
                    command = command.strip()
                    if command:
                        if command in ["SET SESSION big_tables = ON;"]:
                            continue
                        cur.execute(command)
                        result = cur.fetchall()

    def get_conn(self):
        return mysql.connector.connect(
            host=self.db_config["host"],
            port=self.db_config["port"],
            user=self.db_config["username"],
            password=self.db_config["password"],
            database=self.database_name,
            autocommit=True,
        )

    def execute(self, sql, conn):
        with conn.cursor() as cur:
            try:
                cur.execute(sql)
                result = cur.fetchall()
                rowcount = cur.rowcount
                while cur.nextset():
                    pass
                return self.normalize_result(result), rowcount
            except mysql.connector.Error as e:
                cur.fetchall()
                return str(e), -100

    def error_check(self, error_info):
        if "value is out of range" in error_info:
            return False
        return True

    def normalize_result(self, result):
        if result is None:
            return None
        counter = Counter()
        for row in result:
            norm_row = []
            for v in row:
                if v is None:
                    norm_row.append(None)
                    continue
                if isinstance(v, float):
                    norm_row.append(round(v, 6))
                    continue
                if isinstance(v, (bytes, bytearray)):
                    norm_row.append(bytes(v))
                    continue
                norm_row.append(v)
            counter[tuple(norm_row)] += 1
        return str(counter)
