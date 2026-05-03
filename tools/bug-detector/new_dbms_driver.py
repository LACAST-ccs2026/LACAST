import os
import subprocess
import time
from abc import abstractmethod
from collections import Counter

import apsw
import psycopg2
import yaml
import mysql.connector.pooling


class DBMSDriver:
    def __init__(self, **dbms_config):
        self.database_name = dbms_config["database_name"]
        self.schema_path = dbms_config["schema_path"]
        self.db_config = dbms_config["db_config"]
        self.pool = None

    @abstractmethod
    def get_dbms_name(self):
        pass

    @staticmethod
    def get_instance(dbms_config_path):
        with open(file=dbms_config_path, mode="r", encoding="utf-8") as f:
            dbms_config = yaml.safe_load(f)
        target_dbms = dbms_config["target_dbms"]
        if target_dbms == "mysql":
            return MySQLDriver(**dbms_config)
        if target_dbms == "tidb":
            return TiDBDriver(**dbms_config)
        if target_dbms == "postgres":
            return PostgreSQLDriver(**dbms_config)
        if target_dbms == "mariadb":
            return MariadbDriver(**dbms_config)
        if target_dbms == "sqlite":
            return SQLiteDriver(**dbms_config)
        else:
            raise ValueError(f"{target_dbms} is not supported")

    @abstractmethod
    def build_schema(self):
        pass

    @abstractmethod
    def get_default_conn(self):
        pass

    @abstractmethod
    def get_conn(self):
        pass

    @abstractmethod
    def execute(self, sql, conn):
        pass

    @abstractmethod
    def error_check(self, error_info):
        pass

    @abstractmethod
    def normalize_result(self, result):
        pass

    @abstractmethod
    def test_connection(self):
        pass

    @abstractmethod
    def restart_server(self):
        pass

class MySQLDriver(DBMSDriver):
    def __init__(self, **dbms_config):
        super().__init__(**dbms_config)
        self.host = self.db_config["host"]
        self.port = self.db_config["port"]
        self.username = self.db_config["username"]
        self.password = self.db_config["password"]

    def get_dbms_name(self):
        return "mysql"

    def build_schema(self):
        with mysql.connector.connect(host=self.db_config["host"], port=self.db_config["port"], user=self.db_config["username"], password=self.db_config["password"], database="mysql", autocommit=True) as con:
            with con.cursor() as cur:
                cur.execute(f"DROP DATABASE IF EXISTS `{self.database_name}`;")
                cur.execute(f"CREATE DATABASE `{self.database_name}`;")

        with mysql.connector.connect(host=self.db_config["host"], port=self.db_config["port"], user=self.db_config["username"], password=self.db_config["password"], database=self.database_name, autocommit=True) as con:
            with con.cursor() as cur:
                with open(file=self.schema_path, mode="r", encoding="utf-8") as f:
                    sql_file = f.read()
                sql_commands = sql_file.split(';')
                for command in sql_commands:
                    command = command.strip()
                    if command:
                        if command in ["SET SESSION big_tables = ON;"]:
                            continue
                        cur.execute(command)
                        result = cur.fetchall()

    def get_default_conn(self):
        return mysql.connector.connect(
            host=self.db_config["host"],
            port=self.db_config["port"],
            user=self.db_config["username"],
            password=self.db_config["password"],
            database="mysql",
            autocommit=True
        )

    def get_conn(self):
        return mysql.connector.connect(
            host=self.db_config["host"],
            port=self.db_config["port"],
            user=self.db_config["username"],
            password=self.db_config["password"],
            database=self.database_name,
            autocommit=True
        )

    def execute(self, sql, conn):
        with conn.cursor() as cur:
            try:
                cur.execute(sql)
                result = cur.fetchall()
                rowcount = cur.rowcount
                while cur.nextset():
                    pass
                return self.normalize_result(result).replace("sqlcraft_radar_raw", "sqlcraft_radar"), rowcount
            except mysql.connector.Error as e:
                cur.fetchall()
                return str(e).replace("sqlcraft_radar_raw", "sqlcraft_radar"), -100

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
                    norm_row.append("NULL")
                    continue

                if isinstance(v, float):
                    norm_row.append(str(round(v, 6)))
                    continue

                if isinstance(v, (bytes, bytearray)):
                    norm_row.append(bytes(v).hex())
                    continue

                norm_row.append(str(v))

            key = "|".join(norm_row)
            counter[key] += 1

        return str(counter)

    def test_connection(self):
        try:
            conn = self.get_default_conn()
            with conn.cursor() as cur:
                cur.execute("SELECT 1;")
                result = cur.fetchall()
            conn.close()
            return True
        except Exception as e:
            return False

    def restart_server(self):
        container_name = "mysql8"
        subprocess.run(["docker", "restart", container_name], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        # subprocess.run(["bash", r"/app/dbms/scripts/mysql/restart_mysql848.sh"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        for i in range(6):
            time.sleep(2)
            if self.test_connection():
                return True
            time.sleep(6)
        return self.test_connection()

class TiDBDriver(DBMSDriver):
    def __init__(self, **dbms_config):
        super().__init__(**dbms_config)
        self.host = self.db_config["host"]
        self.port = self.db_config["port"]
        self.username = self.db_config["username"]
        self.password = self.db_config["password"]

    def get_dbms_name(self):
        return "tidb"

    def build_schema(self):
        with mysql.connector.connect(
            host=self.host,
            port=self.port,
            user=self.username,
            password=self.password,
            database="mysql",
            autocommit=True
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
            autocommit=True
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

    def get_default_conn(self):
        conn = mysql.connector.connect(
            host=self.host,
            port=self.port,
            user=self.username,
            password=self.password,
            database="mysql",
            autocommit=True
        )
        return conn

    def get_conn(self):
        conn = mysql.connector.connect(
            host=self.host,
            port=self.port,
            user=self.username,
            password=self.password,
            database=self.database_name,
            autocommit=True
        )
        with conn.cursor() as cur:
            cur.execute("SET GLOBAL sql_mode = (SELECT REPLACE(@@GLOBAL.sql_mode, 'ONLY_FULL_GROUP_BY', ''));")
            cur.execute("SET SESSION sql_mode = (SELECT REPLACE(@@SESSION.sql_mode, 'ONLY_FULL_GROUP_BY', ''));")
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
                return self.normalize_result(result).replace("sqlcraft_radar_raw", "sqlcraft_radar"), rowcount

            except mysql.connector.Error as e:
                return str(e).replace("sqlcraft_radar_raw", "sqlcraft_radar"), -100
            except Exception as e:
                return str(e).replace("sqlcraft_radar_raw", "sqlcraft_radar"), -200


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
                    norm_row.append("NULL")
                    continue

                if isinstance(v, float):
                    norm_row.append(str(round(v, 6)))
                    continue

                if isinstance(v, (bytes, bytearray)):
                    norm_row.append(bytes(v).hex())
                    continue

                norm_row.append(str(v))

            key = "|".join(norm_row)
            counter[key] += 1

        return str(counter)

    def test_connection(self):
        try:
            conn = self.get_default_conn()
            with conn.cursor() as cur:
                cur.execute("SELECT 1;")
                result = cur.fetchall()
            conn.close()
            return True
        except Exception as e:
            return False

    def restart_server(self):
        container_name = "tidb"
        try:
            subprocess.run(["docker", "restart", container_name], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except:
            pass
        for i in range(6):
            time.sleep(2)
            if self.test_connection():
                return True
            time.sleep(6)
        return self.test_connection()


class PostgreSQLDriver(DBMSDriver):

    def __init__(self, **dbms_config):
        super().__init__(**dbms_config)

        self.host = self.db_config["host"]
        self.port = self.db_config.get("port", 5432)
        self.username = self.db_config["username"]
        self.password = self.db_config["password"]

    def get_dbms_name(self):
        return "postgresql"

    def build_schema(self):
        conn = psycopg2.connect(
            host=self.host,
            port=self.port,
            user=self.username,
            password=self.password,
            database="postgres"
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
            database=self.database_name
        )

        conn.autocommit = True

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

                    try:
                        cur.fetchall()
                    except Exception:
                        pass

                except Exception as e:
                    print("Postgres Schema Error:", e)

        conn.close()

    def get_default_conn(self):
        return psycopg2.connect(
            host=self.host,
            port=self.port,
            user=self.username,
            password=self.password,
            database="postgres"
        )

    def get_conn(self):

        return psycopg2.connect(
            host=self.host,
            port=self.port,
            user=self.username,
            password=self.password,
            database=self.database_name
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

                return self.normalize_result(result).replace(
                    "sqlcraft_radar_raw", "sqlcraft_radar"
                ), rowcount

            except psycopg2.Error as e:

                conn.rollback()

                return str(e).replace(
                    "sqlcraft_radar_raw", "sqlcraft_radar"
                ), -100

            except Exception as e:

                conn.rollback()

                return str(e).replace(
                    "sqlcraft_radar_raw", "sqlcraft_radar"
                ), -200

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
                    norm_row.append("NULL")
                    continue

                if isinstance(v, float):
                    norm_row.append(str(round(v, 6)))
                    continue

                if isinstance(v, memoryview):
                    norm_row.append(bytes(v).hex())
                    continue

                if isinstance(v, (bytes, bytearray)):
                    norm_row.append(bytes(v).hex())
                    continue

                norm_row.append(str(v))

            key = "|".join(norm_row)

            counter[key] += 1

        return str(counter)

    def test_connection(self):

        try:

            conn = self.get_default_conn()

            with conn.cursor() as cur:
                cur.execute("SELECT 1;")
                cur.fetchall()

            conn.close()

            return True

        except Exception:

            return False

    def restart_server(self):
        container_name = "postgres"
        subprocess.run(["docker", "restart", container_name], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        # subprocess.run(["bash", r"/app/dbms/scripts/postgres/restart_postgres183.sh"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        for i in range(6):
            time.sleep(2)
            if self.test_connection():
                return True
            time.sleep(6)
        return self.test_connection()


class MariadbDriver(DBMSDriver):
    def __init__(self, **dbms_config):
        super().__init__(**dbms_config)
        self.host = self.db_config["host"]
        self.port = self.db_config["port"]
        self.username = self.db_config["username"]
        self.password = self.db_config["password"]

    def get_dbms_name(self):
        return "mariadb"

    def build_schema(self):
        with mysql.connector.connect(host=self.db_config["host"], port=self.db_config["port"], user=self.db_config["username"], password=self.db_config["password"], database="mysql", autocommit=True) as con:
            with con.cursor() as cur:
                cur.execute(f"DROP DATABASE IF EXISTS `{self.database_name}`;")
                cur.execute(f"CREATE DATABASE `{self.database_name}`;")

        with mysql.connector.connect(host=self.db_config["host"], port=self.db_config["port"], user=self.db_config["username"], password=self.db_config["password"], database=self.database_name, autocommit=True) as con:
            with con.cursor() as cur:
                with open(file=self.schema_path, mode="r", encoding="utf-8") as f:
                    sql_file = f.read()
                sql_commands = sql_file.split(';')
                for command in sql_commands:
                    command = command.strip()
                    if command:
                        if command in ["SET SESSION big_tables = ON;"]:
                            continue
                        if "SET SESSION sql_log_off = OFF" in command:
                            continue
                        cur.execute(command)
                        result = cur.fetchall()

    def get_default_conn(self):
        return mysql.connector.connect(
            host=self.db_config["host"],
            port=self.db_config["port"],
            user=self.db_config["username"],
            password=self.db_config["password"],
            database="mysql",
            autocommit=True
        )

    def get_conn(self):
        return mysql.connector.connect(
            host=self.db_config["host"],
            port=self.db_config["port"],
            user=self.db_config["username"],
            password=self.db_config["password"],
            database=self.database_name,
            autocommit=True
        )

    def execute(self, sql, conn):
        with conn.cursor() as cur:
            try:
                cur.execute(sql)
                result = cur.fetchall()
                rowcount = cur.rowcount
                while cur.nextset():
                    pass
                return self.normalize_result(result).replace("sqlcraft_radar_raw", "sqlcraft_radar"), rowcount
            except mysql.connector.Error as e:
                cur.fetchall()
                return str(e).replace("sqlcraft_radar_raw", "sqlcraft_radar"), -100

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
                    norm_row.append("NULL")
                    continue

                if isinstance(v, float):
                    norm_row.append(str(round(v, 6)))
                    continue

                if isinstance(v, (bytes, bytearray)):
                    norm_row.append(bytes(v).hex())
                    continue

                norm_row.append(str(v))

            key = "|".join(norm_row)
            counter[key] += 1

        return str(counter)

    def test_connection(self):
        try:
            conn = self.get_default_conn()
            with conn.cursor() as cur:
                cur.execute("SELECT 1;")
                result = cur.fetchall()
            conn.close()
            return True
        except Exception as e:
            return False

    def restart_server(self):
        container_name = "mariadb"
        subprocess.run(["docker", "restart", container_name], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        # subprocess.run(["bash", r"/app/dbms/scripts/mysql/restart_mysql848.sh"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        for i in range(6):
            time.sleep(2)
            if self.test_connection():
                return True
            time.sleep(6)
        return self.test_connection()

class SQLiteDriver(DBMSDriver):
    def __init__(self, **dbms_config):
        super().__init__(**dbms_config)
        self.db_path = self.db_config.get("db_path", f"{self.database_name}.db")

    def get_dbms_name(self):
        return "sqlite"

    def build_schema(self):
        if os.path.exists(self.db_path):
            os.remove(self.db_path)

        conn = apsw.Connection(self.db_path)
        cursor = conn.cursor()

        with open(self.schema_path, "r", encoding="utf-8") as f:
            sql_file = f.read()

        sql_commands = [s.strip() for s in sql_file.split(";") if s.strip()]

        for cmd in sql_commands:
            try:
                cursor.execute(cmd)
            except Exception as e:
                print("SQLite Schema Error:", e)

        conn.close()

    def get_default_conn(self):
        return apsw.Connection(self.db_path)

    def get_conn(self):
        return apsw.Connection(self.db_path)

    def execute(self, sql, conn):
        cursor = conn.cursor()

        try:
            result = []
            for row in cursor.execute(sql):
                result.append(row)

            rowcount = len(result)

            return self.normalize_result(result).replace(
                "sqlcraft_radar_raw", "sqlcraft_radar"
            ), rowcount

        except Exception as e:
            return str(e).replace(
                "sqlcraft_radar_raw", "sqlcraft_radar"
            ), -100

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
                    norm_row.append("NULL")
                    continue

                if isinstance(v, float):
                    norm_row.append(str(round(v, 6)))
                    continue

                if isinstance(v, (bytes, bytearray)):
                    norm_row.append(bytes(v).hex())
                    continue

                norm_row.append(str(v))

            key = "|".join(norm_row)
            counter[key] += 1

        return str(counter)

    def test_connection(self):
        try:
            conn = self.get_conn()
            cursor = conn.cursor()
            list(cursor.execute("SELECT 1;"))
            conn.close()
            return True
        except Exception:
            return False

    def restart_server(self):
        return True