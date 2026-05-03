# LACAST SQL Rule Generator

This repository contains the **SQL Rule Generator** component of the **LACAST** (LLM-Assisted Context-Aware SQL Grammar Transformer) framework, submitted to **CCS 2026**. The system automatically learns and validates SQL syntax production rules for multiple database management systems (DBMS) using a **LangGraph-based** agentic workflow.

The grammar engine used for SQL parsing and generation is **SQLCraft** (now renamed to **LACAST** engine). The original name is retained in the JAR file (`SQLCraft-1.0.jar`) and configuration directories (`configs/sqlcraft/`) for compatibility.

**Core hypothesis:** By combining LLM-driven rule generation with real DBMS execution feedback, the system can accurately infer SQL grammar rules that reflect the syntactic behaviour of a target database system, producing a complete grammar that can be used for automated SQL fuzzing and query generation.

## Project Structure

```
lacast_sql_rule_generator/
├── main.py                          # CLI entry point
├── config.py                        # Configuration classes
├── graph.py                         # LangGraph StateGraph assembly
├── state.py                         # TypedDict-based state definitions
│
├── nodes/                           # Graph node functions
├── services/                        # External service layer
├── utils/                           # Utility modules
├── prompts/                         # LLM prompt templates (.txt)
├── configs/                         # Runtime configuration (see §Configuration)
│   ├── dbms/                        #   DBMS connection settings (YAML)
│   └── sqlcraft/                    #   LACAST engine config templates (per DBMS)
├── workdirs/                        # Pre-trained results (one subdirectory per DBMS)
├── SQLCraft-1.0.jar                 # LACAST grammar engine (formerly SQLCraft)
├── requirements.txt                 # Python dependencies
└── .env.example                     # LLM API configuration template
```

## Requirements

- **Python** 3.12+
- **Java** 11+ (for LACAST.jar)
- **LLM API** endpoint (OpenAI-compatible, e.g., OpenAI, DeepSeek, etc.)
- At least one target database among:
  - **SQLite** (zero-config, built-in support)
  - **MySQL** / **MariaDB**
  - **PostgreSQL**
  - **TiDB**

## Setup

### 1. Install Python dependencies

```bash
python -m venv .venv
source .venv/bin/activate         # Linux/macOS
.venv\Scripts\activate            # Windows
pip install -r requirements.txt
```

### 2. Configure LLM API

```bash
cp .env.example .env
```

Edit `.env` with your LLM provider details:

```
LLM_MODEL=gpt-4o-mini
LLM_API_KEY=sk-your-api-key-here
LLM_BASE_URL=https://api.openai.com/v1
LLM_TEMPERATURE=0.0
```

### 3. Configure database connection

Each DBMS has a YAML configuration file under `configs/dbms/`. For example, `configs/dbms/mysql.yaml`:

```yaml
target_dbms: "mysql"
database_name: "lacast"
schema_path: "spec/2.sql"
max_connections: 1
db_config:
  host: "127.0.0.1"
  port: "3306"
  username: "root"
  password: "123456"
```

For SQLite, no external database server is needed. The default config at `configs/dbms/sqlite.yaml` works out of the box.

### 4. Prepare the working directory

Create a working directory and place the input feature knowledge base inside it:

```bash
mkdir -p workdirs/my_experiment
# Place web_corpus.json in workdirs/my_experiment/
```

The repository also includes pre-trained results for all 5 DBMSes in `workdirs/` — these can be used directly for grammar export or as a starting point for incremental training.

## Configuration

The `configs/` directory contains two kinds of configuration files.

### DBMS Connection Config (`configs/dbms/`)

One YAML file per DBMS (`mysql.yaml`, `sqlite.yaml`, `postgres.yaml`, etc.), specifying:

| Field | Description |
|-------|-------------|
| `target_dbms` | DBMS identifier (e.g., `mysql`, `sqlite`) |
| `database_name` | Database to create for testing |
| `schema_path` | SQL schema file (DDL) for test tables |
| `max_connections` | Maximum concurrent DBMS connections |
| `db_config` | Host, port, username, password |

### LACAST Engine Config (`configs/sqlcraft/<dbms>/`)

Contains templates for the LACAST grammar engine (retaining the original `sqlcraft` directory name), one subdirectory per DBMS:

| File | Purpose |
|------|---------|
| `configs.json` | Engine parameters: grammar path, datatype path, start rule, maximum derivation depth, feature flags (e.g., `AGG_ONLY_IN_GB`, `HAVING_USE_SELECT`, `OUTER_REF_ENABLED`) |
| `datatypes/types.json` | List of supported SQL datatypes for the target DBMS |
| `grammars/base.g4` | Base ANTLR grammar template — defines the core SQL query structure (SELECT, FROM, WHERE, subqueries, set operations, etc.) |
| `schema/1.json` | Database schema metadata used by the engine |

At runtime, these templates are copied per LACAST engine instance. Paths in `configs.json` use relative paths, which are resolved to absolute paths when the instance is created.

## Input: The Feature Knowledge Base

The sole input to the training process is **`web_corpus.json`**, placed in the working directory. It contains the syntactic feature knowledge base for the target DBMS:

```json
{
    "Aggregate SQL Functions": {
        "avg(X)": [
            "The AVG() function returns the average value of an expression..."
        ],
        "count(*)": [
            "The COUNT() function returns the number of records..."
        ]
    },
    "Core SQL Functions": {
        "abs(X)": [
            "The ABS() function returns the absolute value of X..."
        ]
    }
}
```

Each top-level key is a **syntax type** (e.g., `"Aggregate SQL Functions"`). Within each type, keys are **raw syntax names** (e.g., `"avg(X)"`) and values are arrays of natural language descriptions explaining the syntax and semantics of the feature.

> **Note:** The `web_corpus.json` can be obtained by running a dedicated crawler script against the official DBMS documentation (e.g., MySQL Reference Manual, SQLite Language Expressions, PostgreSQL documentation). The crawler extracts function signatures and their descriptions into this structured JSON format.

## Usage

### CLI Parameters

```
python main.py --dbms <dbms> --work-dir <dir> [options]
```

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `--dbms` | Yes | — | Target DBMS identifier. Supported: `sqlite`, `mysql`, `mariadb`, `postgres`, `tidb` |
| `--work-dir` | Yes | — | Working directory path. Must contain `web_corpus.json` (input). All outputs (`grammar.g4`, `trained_features.json`, `training_state.json`, `data/`) are written here |
| `--limit` | No | `0` | Maximum number of features to train in this session. `0` means unlimited (train all untrained features). Use this for incremental batch training: run with `--limit 5`, then `--limit 10`, etc. Progress accumulates in `training_state.json`. |
| `--timeout` | No | `0` | Soft timeout in minutes. `0` means no timeout. The current feature completes before stopping, ensuring `trained_features.json` and `training_state.json` are never partially written. Useful for long-running experiments. |
| `--no-fix` | No | `false` | Ablation mode: skip the LLM-based repair step. Rules that fail DBMS execution are discarded immediately. Used for **Ablation Study 2** (iterative-fix ablation) to measure the contribution of the fix loop. |

### Examples

```bash
# 1. Train all features for SQLite (basic usage)
python main.py --dbms sqlite --work-dir ./workdirs/sqlite

# 2. Train the first 5 features for MySQL
python main.py --dbms mysql --work-dir ./workdirs/mysql_001 --limit 5

# 3. Train with a 30-minute timeout (PostgreSQL)
python main.py --dbms postgres --work-dir ./workdirs/postgres_001 --timeout 30

# 4. Ablation study: skip LLM repair step
python main.py --dbms sqlite --work-dir ./workdirs/ablation_test --no-fix

# 5. Incremental training (batch 1: train first 10 features)
python main.py --dbms tidb --work-dir ./workdirs/tidb_001 --limit 10
#    (run again later for next batch)
python main.py --dbms tidb --work-dir ./workdirs/tidb_001 --limit 20

# 6. Quick validation: train just 1 feature with a 5-minute timeout
python main.py --dbms sqlite --work-dir ./workdirs/quick_test --limit 1 --timeout 5
```

### Re-export Grammar from Pre-trained Results

If a `trained_features.json` already exists (e.g., in the provided `workdirs/`) and you only need to regenerate `grammar.g4` without re-running training:

```bash
# Using the standalone grammar exporter
python -m utils.grammar_exporter --dbms sqlite --work-dir ./workdirs/sqlite

# Or by running main.py (it detects all features are already trained
# and exports the grammar immediately)
python main.py --dbms sqlite --work-dir ./workdirs/sqlite
```

## Output Structure

After a training run, the working directory contains the following:

```
<work_dir>/
├── grammar.g4                   # (PRIMARY OUTPUT) Complete generated grammar
├── trained_features.json        # All successfully trained rules
├── training_state.json          # Training progress (for incremental resumption)
├── data/                        # Per-feature intermediate rule files
│   ├── Aggregate SQL Functions/
│   │   └── agg_AVG/
│   │       ├── basic_info.json
│   │       ├── rule_0.json
│   │       ├── rule_1.json
│   │       └── const_productions.json
│   └── ...
├── memory.db                    # SQLite fix-experience database (auto-created)
└── .jar_instances/              # LACAST engine runtime instances (auto-created)
    ├── instance_0/
    └── ...
```

### grammar.g4 (Primary Output)

The complete ANTLR-style grammar file generated from all trained rules. This is the **primary output artifact** of the system.

The grammar includes:
- **Base grammar** — SELECT, FROM, WHERE, GROUP BY, ORDER BY, subqueries, set operations (`UNION`, `INTERSECT`, `EXCEPT`), joins, CTEs (`WITH`), etc.
- **Datatype evaluators** — one per supported SQL type (e.g., `integer_evaluator`, `real_evaluator`, `text_evaluator`, `blob_evaluator`)
- **Aggregate evaluators** — one per supported type (e.g., `real_AGG_evaluator`, `integer_AGG_evaluator`)
- **Trained feature rules** — all successfully trained features (aggregate functions, arithmetic/bit/comparison operators, string/date/mathematical functions, etc.)
- **Constant productions** — keyword constants (e.g., `DISTINCT`, `ASC`, `DESC`)

This file can be directly loaded by the LACAST engine to generate valid SQL queries for the target DBMS.

### trained_features.json

The master record of all trained grammar rules:

```json
{
    "agg_AVG": {
        "syntax_name": "agg_AVG",
        "raw_syntax_name": "avg(X)",
        "is_agg": true,
        "syntax_type": "Aggregate SQL Functions",
        "eval2lefts": {
            "real_AGG_evaluator": ["AVG_real_evaluator"]
        },
        "left2rights": {
            "AVG_real_evaluator": [
                "\"AVG(\"_var_integer \")\"",
                "\"AVG(\"real_evaluator_without_agg \")\""
            ]
        },
        "const_prods": {
            "AVG_DISTINCT": ["\"DISTINCT\""]
        }
    }
}
```

- **`eval2lefts`** — maps each type/evaluator to its left-hand-side nonterminals.
- **`left2rights`** — maps each left-hand-side to its right-hand-side production alternatives (each alternative is quoted and escaped for JSON serialisation).
- **`const_prods`** — constant/keyword productions (e.g., `"DISTINCT"`).

This file is the persistent state of all learned rules. When running incrementally (`--limit`), previously trained rules are read from this file.

### training_state.json

Persistent training progress record that enables incremental training and resumption:

```json
{
    "dbms": "sqlite",
    "updated_at": "2026-05-01T06:46:12Z",
    "completed_features": ["avg(X)", "count(*)"],
    "failed_features": [
        {"raw_syntax_name": "some_func(X)", "reason": "All rules failed: unsupported datatype"}
    ]
}
```

On start-up, the system reads this file (or creates it if absent) and skips already completed or failed features. Running with `--limit N` trains N new features per session and appends to this file, enabling batch training across multiple sessions.

### data/ Directory

Per-feature intermediate files created during training:

```
data/<syntax_type>/<normalized_name>/
├── basic_info.json          # Feature metadata (raw name, syntax type, etc.)
├── rule_<i>.json            # One file per generated rule (type_eval, left, right)
└── const_productions.json   # Constant productions for this feature
```

Each `rule_<i>.json` contains a single production alternative. The LLM fix loop updates these files during the fix → test → fix cycle. After training, the consolidated rules are stored in `trained_features.json`, and the `data/` directory can be safely removed.

## Training Workflow

The system uses a two-layer graph architecture:

```
Main Graph (Orchestrator)                              Subgraph (Feature Trainer)
─────────────────────────                              ──────────────────────────
  init                                                    select_feature
    │  Read web_corpus.json                                  │  Normalize name, create directory
    │  + training_state.json                                 ▼
    ▼                                                     generate_rules (LLM)
  pick_next                                                  │  Generate N rules from feature info
    │  Select next untrained feature                         ▼
    ▼                                                     fan_out (sequential)
  feature_trainer ═════════════════════════════════╗           │  For each rule:
    │  Acquire LACAST instance from pool          ║           ├── single_pipeline
    │  Invoke subgraph                            ║           │     test (via LACAST engine)
    ▼                                              ║           │     ↓ if failed
  record_result                                    ║           │     evaluate (LLM)
    │  Persist training_state.json                 ║           │     ↓ if fixable
    │  Check timeout                               ║           │     fix (LLM + Memory Store)
    ▼                                              ║           │     ↓
  ─── loop back to pick_next ──                    ║           │     test again
                                                   ║           │     ↻ up to 3 fix attempts
                                                   ║           ▼
                                                   ║         fan_in
                                                   ║           │  Collect results
                                                   ║           ▼
                                                   ║         save_results / summarize_failure
                                                   ║           │  Save passed rules
                                                   ║           │  Write fix episodes to Memory Store
                                                   ╚═══════════╝
```

### Key Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Feature ordering | Aggregate functions first | Aggregates are prerequisites for many other features |
| Rule testing | Sequential (within a feature) | LangGraph `Send()` not supported in subgraph invoke mode |
| Fix strategy | Retrieve-on-Failure | 1st attempt: LLM-only; 2nd+: search Memory Store for similar past fixes |
| Max fix attempts | 3 | Beyond this, the rule is discarded |
| LACAST engine pool | 4 instances, acquire/release | Prevents engine crashes from cascading across features |

## Ablation Studies

The LACAST framework supports two ablation configurations:

1. **Ablation 1 — No semantic context** (separate experiment, see `ablation_study_1/` at project root): Strips the scope dependency and type dependency modules, retaining only syntactic production rules. This measures the contribution of semantic constraints to SQL generation accuracy.

2. **Ablation 2 — No iterative fix** (`--no-fix` flag): Disables the LLM repair loop. Rules that fail DBMS execution are discarded immediately without LLM repair. This isolates the contribution of the fix mechanism from rule generation.

## Supported DBMS

| DBMS | Driver | Notes |
|------|--------|-------|
| SQLite | Built-in `sqlite3` | Zero configuration, file-based |
| MySQL | `mysql-connector-python` | MySQL 8.x+ |
| MariaDB | `mysql-connector-python` | Compatible with MySQL protocol |
| PostgreSQL | `psycopg2-binary` | PostgreSQL 12+ |
| TiDB | `mysql-connector-python` | MySQL-compatible distributed SQL |

## Notes

- **Grammar output**: After training completes, `grammar.g4` is automatically generated in the working directory by `GrammarExporter`. This is the final output artifact — it can be used directly with the SQLCraft engine (`SQLCraft-1.0.jar`, the LACAST engine) for SQL generation.
- **Standalone export**: To regenerate `grammar.g4` from an existing `trained_features.json` without re-running training: `python -m utils.grammar_exporter --dbms <dbms> --work-dir <dir>`.
- **Incremental training**: Use `--limit N` to train in batches. Progress is saved to `training_state.json`, enabling resumption across sessions. The system skips already completed and failed features on start-up.
- **Timeout**: The `--timeout M` flag sets a soft timeout in minutes. The current feature completes before stopping, ensuring `trained_features.json` and `training_state.json` are never partially written.
- **Pre-trained results**: The `workdirs/` directory contains pre-trained rules and grammars for all 5 DBMSes. Running `python main.py` against these will detect that all features are trained and export `grammar.g4` immediately.
- **Engine instances**: During training, per-rule grammars are written to temporary engine instance directories (`<work_dir>/.jar_instances/instance_N/grammars/grammar.g4`) for testing via `SQLCraft-1.0.jar`. These per-instance grammars contain only the rule under test and should not be used as the final output. The complete grammar is written to `<work_dir>/grammar.g4` at the end of training.
- **Data directory**: The `data/` subdirectory contains intermediate per-feature rule files. It can be safely deleted after training; the consolidated rules are stored in `trained_features.json`.
