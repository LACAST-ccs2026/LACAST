# Preliminary Experiment: LLM-based SQL Fuzzing

This directory contains the code for the **preliminary experiment** of our CCS 2026 submission. The experiment evaluates the correctness and efficiency of using a Large Language Model (LLM) to generate SQL queries for fuzzing purposes.

**Core hypothesis:** Relying solely on an LLM to generate valid SQL queries results in low execution accuracy and high generation latency.

## Project Structure

```
preliminary_experiment/
├── main.py                  # Entry point
├── llm_client.py            # LLM API client (OpenAI-compatible)
├── fuzzer.py                # Fuzzing loop: generate SQL -> execute -> log
├── analyzer.py              # Offline results analyzer
├── results_logger.py        # Logging and statistics
├── db_manager.py            # Database manager wrapper
├── dbms_driver.py           # DBMS-specific drivers (MySQL, MariaDB, PostgreSQL, SQLite, TiDB)
├── test_*.py                # Unit tests
├── .env.example             # LLM API configuration template
├── requirements.txt         # Python dependencies
├── dbms/                    # DBMS connection configurations
│   ├── mysql.yaml
│   ├── mariadb.yaml
│   ├── postgres.yaml
│   ├── postgresql.yaml
│   ├── sqlite.yaml
│   └── tidb.yaml
├── schemas/                 # Database schemas (JSON descriptions + SQL DDL)
│   ├── mysql/
│   ├── mariadb/
│   ├── postgres/
│   ├── tidb/
│   └── sqlite/
└── results/                 # Generated fuzzing results (example data included)
    ├── results_*.jsonl      # Per-query logs (primary output format)
    └── statistics_*.json    # Aggregated statistics
```

## Requirements

- Python 3.10+
- Access to an LLM API endpoint (OpenAI-compatible, e.g., OpenAI API, DeepSeek, etc.)
- At least one target database system from the supported list:
  - MySQL / MariaDB
  - PostgreSQL
  - SQLite (zero-config, built-in support)
  - TiDB

## Setup

### 1. Clone and install dependencies

```bash
# (Recommended) Create a virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### 2. Configure LLM API

Copy the environment template and fill in your API credentials:

```bash
cp .env.example .env
```

Edit `.env` with your LLM provider details:

```
# LLM Configuration
LLM_MODEL=gpt-4o-mini
LLM_API_KEY=your-api-key-here
LLM_BASE_URL=https://api.openai.com/v1
LLM_TEMPERATURE=0.0
```

### 3. Configure target database

Each DBMS has a configuration file under `dbms/`. For example, `dbms/mysql.yaml`:

```yaml
target_dbms: "mysql"
database_name: "lacast"
schema_path: "schemas/mysql/2.sql"
max_connections: 1
db_config:
  host: "127.0.0.1"
  port: "3306"
  username: "root"
  password: "123456"
```

Make sure the target database is running and accessible. For SQLite, no external setup is required.

## Running the Fuzzer

```bash
python main.py --dbms <dbms_name> --duration <minutes>
```

Example `--dbms` values: `mysql`, `mariadb`, `postgres`, `sqlite`, `tidb`. These are just examples; the framework supports any DBMS that can be integrated by implementing the `DBMSDriver` interface.

### Examples

```bash
# Run fuzzer against SQLite for 10 minutes
python main.py --dbms sqlite --duration 10

# Run fuzzer against MySQL for 60 minutes
python main.py --dbms mysql --duration 60

# Run fuzzer against PostgreSQL for 30 minutes
python main.py --dbms postgres --duration 30
```

### What happens during execution

1. The fuzzer initializes the database schema (creates tables and populates sample data).
2. It enters a loop that repeatedly:
   - Asks the LLM to generate a SQL query based on the schema.
   - Executes the query against the target database.
   - Logs the result (success/failure, error message, generation time, token usage).
3. After the specified duration, it prints aggregated statistics and saves them to `results/`.

### Understanding the output

- **Console output:** Each generated SQL query is printed with its status (`Success` or `Failed (error message)`).
- **`results/results_<dbms>.jsonl`:** Per-query log in JSON Lines format. Each line contains:
  - `timestamp`: Unix timestamp of execution
  - `sql`: The extracted SQL query (single line)
  - `raw_sql`: Raw LLM response before extraction
  - `success`: `true` or `false`
  - `error_message`: Error details if execution failed
  - `generation_time`: Time spent waiting for LLM response (seconds)
  - `prompt_tokens` / `completion_tokens`: Token usage from the LLM API
- **`results/statistics_<dbms>.json`:** Aggregated statistics including total queries, accuracy, average generation speed, and total token consumption.

## Analyzing Results

After the fuzzer finishes, use the analyzer to get a summary from a JSONL result file:

```bash
python analyzer.py --file results/results_mysql.jsonl
```

The analyzer prints:
- Total queries generated (successful vs. failed)
- Execution accuracy percentage
- Average generation speed (queries/second)
- Total prompt, completion, and combined tokens consumed

## Running Tests

```bash
python -m unittest discover -p "test_*.py"
```

## Supported DBMS

| DBMS        | Driver Library         | Notes                                          |
|-------------|------------------------|-------------------------------------------------|
| MySQL       | `mysql-connector-python` | Standard MySQL 8.x+                             |
| MariaDB     | `mysql-connector-python` | Compatible with MySQL protocol                  |
| PostgreSQL  | `psycopg2-binary`        | PostgreSQL 12+                                  |
| SQLite      | Built-in `sqlite3`       | Zero configuration, file-based                  |
| TiDB        | `mysql-connector-python` | MySQL-compatible, distributed SQL               |

## Notes

- This is an experimental setup for research purposes. Do not use against production databases.
- SQLite is the easiest way to try the experiment: no server setup is needed.
- The LLM prompt asks for queries with approximately 35 unique tokens to ensure non-trivial complexity.

