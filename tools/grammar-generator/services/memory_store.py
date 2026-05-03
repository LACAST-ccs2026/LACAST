import json
import sqlite3
import uuid
from datetime import datetime, timezone
from typing import Optional


class SearchQuery:
    def __init__(
        self,
        dbms: Optional[str] = None,
        error_type: Optional[str] = None,
        syntax_type: Optional[str] = None,
        rule_signature: Optional[str] = None,
        error_summary: Optional[str] = None,
        rule_text: Optional[str] = None,
        top_k: int = 5,
        semantic_first: bool = False,
    ):
        self.dbms = dbms
        self.error_type = error_type
        self.syntax_type = syntax_type
        self.rule_signature = rule_signature
        self.error_summary = error_summary
        self.rule_text = rule_text
        self.top_k = top_k
        self.semantic_first = semantic_first


class MemoryStoreSQLite:
    def __init__(self, db_path: str = ":memory:"):
        self._conn = sqlite3.connect(db_path, check_same_thread=False)
        self._conn.row_factory = sqlite3.Row
        self._init_schema()

    def _init_schema(self):
        self._conn.executescript("""
            CREATE TABLE IF NOT EXISTS episodes (
                episode_id  TEXT PRIMARY KEY,
                timestamp   TEXT NOT NULL,
                dbms        TEXT NOT NULL,
                syntax_type TEXT,
                syntax_name TEXT,
                raw_syntax_name TEXT,
                rule_signature TEXT,
                error_type  TEXT,
                error_summary TEXT,
                success     INTEGER NOT NULL DEFAULT 0,
                hit_count   INTEGER NOT NULL DEFAULT 0,
                last_hit    TEXT,
                full_json   TEXT NOT NULL
            );

            CREATE VIRTUAL TABLE IF NOT EXISTS episodes_fts
                USING fts5(episode_id, dbms, syntax_type, syntax_name,
                           error_type, error_summary, content='episodes',
                           content_rowid='rowid');

            CREATE INDEX IF NOT EXISTS idx_episodes_dbms ON episodes(dbms);
            CREATE INDEX IF NOT EXISTS idx_episodes_error ON episodes(error_type);
            CREATE INDEX IF NOT EXISTS idx_episodes_success ON episodes(success);
        """)

    def save_episode(self, episode: dict) -> str:
        ctx = episode.get("context", {})
        err = episode.get("error", {})
        fix = episode.get("fix", {})
        usage = episode.get("usage", {})
        episode_id = episode.get("episode_id") or f"ep_{uuid.uuid4().hex[:12]}"

        self._conn.execute("""
            INSERT OR REPLACE INTO episodes
                (episode_id, timestamp, dbms, syntax_type, syntax_name,
                 raw_syntax_name, rule_signature, error_type, error_summary,
                 success, hit_count, last_hit, full_json)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            episode_id,
            episode.get("timestamp") or datetime.now(timezone.utc).isoformat(),
            ctx.get("dbms", ""),
            ctx.get("syntax_type", ""),
            ctx.get("syntax_name", ""),
            ctx.get("raw_syntax_name", ""),
            ctx.get("rule_signature", ""),
            err.get("error_type", ""),
            err.get("error_summary", ""),
            1 if fix.get("success") else 0,
            usage.get("hit_count", 0),
            usage.get("last_hit"),
            json.dumps(episode, ensure_ascii=False),
        ))

        self._conn.execute(
            "INSERT OR REPLACE INTO episodes_fts(episode_id, dbms, syntax_type, "
            "syntax_name, error_type, error_summary) VALUES (?,?,?,?,?,?)",
            (episode_id, ctx.get("dbms", ""), ctx.get("syntax_type", ""),
             ctx.get("syntax_name", ""), err.get("error_type", ""),
             err.get("error_summary", ""))
        )

        self._conn.commit()
        return episode_id

    def search_episodes(self, query: SearchQuery) -> list[dict]:
        conditions = ["1=1"]
        params: list = []

        if query.dbms:
            conditions.append("e.dbms = ?")
            params.append(query.dbms)
        if query.error_type:
            conditions.append("e.error_type = ?")
            params.append(query.error_type)
        if query.syntax_type:
            conditions.append("e.syntax_type = ?")
            params.append(query.syntax_type)

        where = " AND ".join(conditions)
        sql = f"""
            SELECT e.full_json FROM episodes e
            WHERE {where}
            ORDER BY e.success DESC, e.hit_count DESC, e.timestamp DESC
            LIMIT ?
        """
        params.append(query.top_k)

        rows = self._conn.execute(sql, params).fetchall()
        return [json.loads(r["full_json"]) for r in rows]

    def increment_hit(self, episode_id: str, success: bool) -> None:
        self._conn.execute("""
            UPDATE episodes SET hit_count = hit_count + 1, last_hit = ?
            WHERE episode_id = ?
        """, (datetime.now(timezone.utc).isoformat(), episode_id))
        self._conn.commit()

    def close(self):
        self._conn.close()

