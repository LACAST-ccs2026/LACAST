import os
import sqlite3
from abc import ABC, abstractmethod
from collections import Counter
from typing import Any, Tuple


class DBMSDriver(ABC):

    @abstractmethod
    def build_schema(self) -> None:
        ...

    @abstractmethod
    def get_conn(self) -> Any:
        ...

    def execute(self, sql: str, conn: Any) -> Tuple[Any, int]:
        cursor = conn.cursor()
        try:
            cursor.execute(sql)
            if cursor.description is not None:
                result = cursor.fetchall()
            else:
                result = []
            rowcount = cursor.rowcount
            if hasattr(conn, "commit"):
                conn.commit()
            return self.normalize_result(result), rowcount
        except Exception as e:
            if hasattr(conn, "rollback"):
                conn.rollback()
            return str(e), -100
        finally:
            cursor.close()

    @abstractmethod
    def error_check(self, error_info: str) -> bool:
        """
        Determine if an error is a real error (should be reported) or an ignorable expected behavior.

        Returns:
            True: Real error, should be reported
            False: Can be ignored
        """
        ...

    def normalize_result(self, result: Any) -> str:
        if result is None:
            return "None"

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


class SQLiteDriver(DBMSDriver):
    def __init__(self, db_path: str, schema_path: str | None = None):
        self.db_path = db_path
        self.schema_path = schema_path

    def build_schema(self) -> None:
        if self.db_path and os.path.exists(self.db_path):
            os.remove(self.db_path)

        if not self.schema_path or not os.path.exists(self.schema_path):
            return

        conn = sqlite3.connect(self.db_path)
        try:
            with open(self.schema_path, "r", encoding="utf-8") as f:
                sql_text = f.read()
            conn.executescript(sql_text)
        finally:
            conn.close()

    def get_conn(self) -> sqlite3.Connection:
        return sqlite3.connect(self.db_path)

    def execute(self, sql: str, conn: sqlite3.Connection) -> Tuple[Any, int]:
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

    def error_check(self, error_info: str) -> bool:
        return True


_SUPPORTED_DBMS = {"sqlite", "mysql", "tidb", "postgres", "mariadb"}


class MySQLDriver(DBMSDriver):
    def __init__(self, host: str, port: int, username: str, password: str,
                 database_name: str, schema_path: str | None = None):
        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.database_name = database_name
        self.schema_path = schema_path

    def build_schema(self) -> None:
        import mysql.connector

        conn_params = dict(
            host=self.host, port=self.port,
            user=self.username, password=self.password,
            autocommit=True,
        )
        with mysql.connector.connect(database="mysql", **conn_params) as con:
            with con.cursor() as cur:
                cur.execute(f"DROP DATABASE IF EXISTS `{self.database_name}`;")
                cur.execute(f"CREATE DATABASE `{self.database_name}`;")

        if self.schema_path and os.path.exists(self.schema_path):
            with mysql.connector.connect(database=self.database_name, **conn_params) as con:
                with con.cursor() as cur:
                    with open(self.schema_path, "r", encoding="utf-8") as f:
                        sql_file = f.read()
                    for cmd in sql_file.split(";"):
                        cmd = cmd.strip()
                        if cmd and not cmd.startswith("SET SESSION big_tables"):
                            cur.execute(cmd)
                            try:
                                cur.fetchall()
                            except Exception:
                                pass

    def get_conn(self):
        import mysql.connector
        return mysql.connector.connect(
            host=self.host, port=self.port,
            user=self.username, password=self.password,
            database=self.database_name, autocommit=True,
        )

    def execute(self, sql, conn):
        cursor = conn.cursor()
        try:
            cursor.execute(sql)
            result = cursor.fetchall()
            rowcount = cursor.rowcount
            while cursor.nextset():
                pass
            return self.normalize_result(result), rowcount
        except Exception as e:
            cursor.fetchall()
            return str(e), -100
        finally:
            cursor.close()

    def error_check(self, error_info: str) -> bool:
        return True


class TiDBDriver(DBMSDriver):
    def __init__(self, host: str, port: int, username: str, password: str,
                 database_name: str, schema_path: str | None = None):
        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.database_name = database_name
        self.schema_path = schema_path

    def build_schema(self) -> None:
        import mysql.connector

        conn_params = dict(
            host=self.host, port=self.port,
            user=self.username, password=self.password,
            autocommit=True,
        )
        with mysql.connector.connect(database="mysql", **conn_params) as con:
            with con.cursor() as cur:
                cur.execute(f"DROP DATABASE IF EXISTS `{self.database_name}`;")
                cur.execute(f"CREATE DATABASE `{self.database_name}`;")

        if self.schema_path and os.path.exists(self.schema_path):
            with mysql.connector.connect(database=self.database_name, **conn_params) as con:
                with con.cursor() as cur:
                    with open(self.schema_path, "r", encoding="utf-8") as f:
                        sql_file = f.read()
                    for cmd in [s.strip() + ";" for s in sql_file.split(";") if s.strip()]:
                        if cmd.upper().startswith("SET "):
                            continue
                        try:
                            cur.execute(cmd)
                            try:
                                cur.fetchall()
                            except Exception:
                                pass
                        except mysql.connector.Error:
                            continue

    def get_conn(self):
        import mysql.connector
        conn = mysql.connector.connect(
            host=self.host, port=self.port,
            user=self.username, password=self.password,
            database=self.database_name, autocommit=True,
        )
        with conn.cursor() as cur:
            cur.execute("SET GLOBAL sql_mode = (SELECT REPLACE(@@GLOBAL.sql_mode, 'ONLY_FULL_GROUP_BY', ''));")
            cur.execute("SET SESSION sql_mode = (SELECT REPLACE(@@SESSION.sql_mode, 'ONLY_FULL_GROUP_BY', ''));")
        return conn

    def execute(self, sql, conn):
        cursor = conn.cursor()
        try:
            cursor.execute(sql)
            try:
                result = cursor.fetchall()
            except Exception:
                result = []
            rowcount = cursor.rowcount
            return self.normalize_result(result), rowcount
        except Exception as e:
            return str(e), -100
        finally:
            cursor.close()

    def error_check(self, error_info: str) -> bool:
        skip_patterns = [
            "baseBuiltinFunc.vecEvalString", "baseBuiltinFunc.evalString",
            "baseBuiltinFunc.vecEvalInt", "Unknown column",
            "Incorrect string value", "value is out of range in",
            "incorrect time value", "Cannot convert string",
        ]
        for pat in skip_patterns:
            if pat in error_info:
                return False
        return True


class PostgreSQLDriver(DBMSDriver):
    def __init__(self, host: str, port: int, username: str, password: str,
                 database_name: str, schema_path: str | None = None):
        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.database_name = database_name
        self.schema_path = schema_path

    def build_schema(self) -> None:
        import psycopg2
        conn = psycopg2.connect(
            host=self.host, port=self.port,
            user=self.username, password=self.password,
            database="postgres",
        )
        conn.autocommit = True
        with conn.cursor() as cur:
            cur.execute(f'DROP DATABASE IF EXISTS "{self.database_name}";')
            cur.execute(f'CREATE DATABASE "{self.database_name}";')
        conn.close()

        if self.schema_path and os.path.exists(self.schema_path):
            conn = psycopg2.connect(
                host=self.host, port=self.port,
                user=self.username, password=self.password,
                database=self.database_name,
            )
            with conn.cursor() as cur:
                with open(self.schema_path, "r", encoding="utf-8") as f:
                    sql_file = f.read()
                for cmd in sql_file.split(";"):
                    cmd = cmd.strip()
                    if not cmd:
                        continue
                    try:
                        cur.execute(cmd)
                    except Exception:
                        pass
            conn.commit()
            conn.close()

    def get_conn(self):
        import psycopg2
        return psycopg2.connect(
            host=self.host, port=self.port,
            user=self.username, password=self.password,
            database=self.database_name,
        )

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
        except Exception as e:
            conn.rollback()
            return str(e), -100
        finally:
            cursor.close()

    def error_check(self, error_info: str) -> bool:
        return True


class MariaDBDriver(DBMSDriver):
    def __init__(self, host: str, port: int, username: str, password: str,
                 database_name: str, schema_path: str | None = None):
        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.database_name = database_name
        self.schema_path = schema_path

    def build_schema(self) -> None:
        import mysql.connector

        conn_params = dict(
            host=self.host, port=self.port,
            user=self.username, password=self.password,
            autocommit=True,
        )
        with mysql.connector.connect(database="mysql", **conn_params) as con:
            with con.cursor() as cur:
                cur.execute(f"DROP DATABASE IF EXISTS `{self.database_name}`;")
                cur.execute(f"CREATE DATABASE `{self.database_name}`;")

        if self.schema_path and os.path.exists(self.schema_path):
            with mysql.connector.connect(database=self.database_name, **conn_params) as con:
                with con.cursor() as cur:
                    with open(self.schema_path, "r", encoding="utf-8") as f:
                        sql_file = f.read()
                    for cmd in sql_file.split(";"):
                        cmd = cmd.strip()
                        if cmd and not cmd.startswith("SET SESSION big_tables"):
                            cur.execute(cmd)
                            try:
                                cur.fetchall()
                            except Exception:
                                pass

    def get_conn(self):
        import mysql.connector
        return mysql.connector.connect(
            host=self.host, port=self.port,
            user=self.username, password=self.password,
            database=self.database_name, autocommit=True,
        )

    def execute(self, sql, conn):
        cursor = conn.cursor()
        try:
            cursor.execute(sql)
            result = cursor.fetchall()
            rowcount = cursor.rowcount
            while cursor.nextset():
                pass
            return self.normalize_result(result), rowcount
        except Exception as e:
            cursor.fetchall()
            return str(e), -100
        finally:
            cursor.close()

    def error_check(self, error_info: str) -> bool:
        if "value is out of range" in error_info:
            return False
        return True


def create_driver(dbms: str, **kwargs) -> DBMSDriver:
    if dbms == "sqlite":
        return SQLiteDriver(**kwargs)
    if dbms == "mysql":
        return MySQLDriver(**kwargs)
    if dbms == "tidb":
        return TiDBDriver(**kwargs)
    if dbms == "postgres":
        return PostgreSQLDriver(**kwargs)
    if dbms == "mariadb":
        return MariaDBDriver(**kwargs)

    raise ValueError(f"Unsupported DBMS: {dbms}. Supported: {_SUPPORTED_DBMS}")
