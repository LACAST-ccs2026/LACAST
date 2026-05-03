

class JavaProgramError(Exception):
    def __init__(self, message):
        self.message = message

class SQLCraftJarError(JavaProgramError):
    def __init__(self, message):
        super().__init__(message)