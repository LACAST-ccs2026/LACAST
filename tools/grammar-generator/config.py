import os
from dataclasses import dataclass, field

from dotenv import load_dotenv

load_dotenv()


@dataclass
class DBMSConfig:

    host: str = "127.0.0.1"
    port: int = 0
    username: str = ""
    password: str = ""
    database_name: str = "sql_rule_test"
    schema_path: str = ""
    db_path: str = ""

    @classmethod
    def from_yaml(cls, dbms: str) -> "DBMSConfig":
        import yaml

        yaml_path = os.path.join(
            os.path.dirname(os.path.abspath(__file__)),
            "configs", "dbms", f"{dbms}.yaml",
        )
        if not os.path.exists(yaml_path):
            raise FileNotFoundError(f"DBMS config not found: {yaml_path}")

        with open(yaml_path, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)

        dc = data.get("db_config", {})
        schema_rel = data.get("schema_path", "")
        schema_path = ""
        if schema_rel:
            schema_path = os.path.normpath(os.path.join(
                os.path.dirname(os.path.abspath(__file__)),
                "configs", "sqlcraft", dbms, "schema", "2.sql"
            ))
            if not os.path.exists(schema_path):
                schema_path = schema_rel

        return cls(
            host=dc.get("host", "127.0.0.1"),
            port=int(dc.get("port", 0)),
            username=dc.get("username", ""),
            password=dc.get("password", ""),
            database_name=data.get("database_name", "sql_rule_test"),
            schema_path=schema_path,
            db_path=dc.get("db_path", ""),
        )


@dataclass
class LLMConfig:
    model: str = field(default_factory=lambda: os.getenv("LLM_MODEL", "gpt-4"))
    api_key: str = field(default_factory=lambda: os.getenv("LLM_API_KEY", ""))
    base_url: str = field(
        default_factory=lambda: os.getenv("LLM_BASE_URL", "https://api.openai.com/v1")
    )
    temperature: float = field(
        default_factory=lambda: float(os.getenv("LLM_TEMPERATURE", "0.3"))
    )


@dataclass
class JarPoolConfig:
    max_instances: int = 4
    jar_path: str = "SQLCraft-1.0.jar"
    base_port: int = 4619
    jar_work_dir: str = ".jar_instances"


@dataclass
class TrainingConfig:
    max_fix_attempts: int = 3
    rules_per_feature: int = 5


@dataclass
class AppConfig:
    dbms: str
    work_dir: str

    llm: LLMConfig = field(default_factory=LLMConfig)
    jar_pool: JarPoolConfig = field(default_factory=JarPoolConfig)
    training: TrainingConfig = field(default_factory=TrainingConfig)

    @property
    def web_corpus_path(self) -> str:
        return os.path.join(self.work_dir, "web_corpus.json")

    @property
    def training_state_path(self) -> str:
        return os.path.join(self.work_dir, "training_state.json")

    @property
    def memory_db_path(self) -> str:
        return os.path.join(self.work_dir, "memory.db")

    @property
    def jar_instances_dir(self) -> str:
        return os.path.join(self.work_dir, self.jar_pool.jar_work_dir)

    def validate(self):
        if not os.path.exists(self.web_corpus_path):
            raise FileNotFoundError(
                f"web_corpus.json not found: {self.web_corpus_path}"
            )
        if not self.llm.api_key:
            raise ValueError("LLM_API_KEY not set, please configure it in the .env file")
