from dbms_driver import DBMSDriver


class DatabaseManager:
    def __init__(self, dbms):
        self.driver = DBMSDriver.get_instance(dbms)

    def init_schema(self):
        self.driver.build_schema()

    def get_conn(self):
        return self.driver.get_conn()

    def execute_sql(self, sql, conn):
        return self.driver.execute(sql, conn)
