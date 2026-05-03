# LACAST without Static Constraints (NoS)

This directory contains the setup for running LACAST without static constraints (scope and type dependencies).

## Overview

In this configuration, we use go-randgen with flat grammar rules extracted from LACAST, without any semantic context (scope and type constraints).

## Prerequisites

- Python 3.10+
- Go 1.12.17 (for building go-randgen)
- At least one target database:
  - MySQL / MariaDB
  - PostgreSQL
  - SQLite (zero-config)
  - TiDB

## Setup

### 1. Build go-randgen

go-randgen requires Go 1.12.17 and `go-bindata`:

```bash
# Install Go 1.12.17
cd /usr/local/
wget https://go.dev/dl/go1.12.17.linux-amd64.tar.gz
tar -C /usr/local -xvzf go1.12.17.linux-amd64.tar.gz

# Set up Go environment
export GOROOT=/usr/local/go
export GOPATH=/app/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Clone and build go-randgen
mkdir /app && cd /app/
git clone https://github.com/pingcap/go-randgen.git
cd go-randgen/
go get github.com/go-bindata/go-bindata/v3/go-bindata@latest
make all
```

Copy the binary:
```bash
cp bin/go-randgen /path/to/setup_NoS/
```

### 2. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 3. Configure Database Connections

Each DBMS has a YAML configuration under `configs/`. Example:

```yaml
target_dbms: "mysql"
database_name: "lacast"
schema_path: "dbms/mysql/mysql.txt"
max_connections: 1
db_config:
  host: "127.0.0.1"
  port: "3306"
  username: "root"
  password: "123456"
```

For SQLite, no external database server is needed.

## Running the Experiment

```bash
# For SQLite (zero-config)
python accuracy_test.py configs/sqlite.yaml

# For MySQL
python accuracy_test.py configs/mysql.yaml

# For PostgreSQL
python accuracy_test.py configs/postgres.yaml

# For MariaDB
python accuracy_test.py configs/mariadb.yaml

# For TiDB
python accuracy_test.py configs/tidb.yaml
```

## Output

- `outputs/<dbms>/running_result.jsonl`: Per-query execution results
- `accuracy_info.json`: Aggregated accuracy

## Project Structure

```
setup_NoS/
├── accuracy_test.py         # Test runner
├── dbms_driver.py           # DBMS drivers
├── requirements.txt         # Dependencies
├── configs/                 # DBMS configurations
├── dbms/                    # Grammar rules and schemas
└── outputs/                 # Generated SQL and results
```

## Notes

- For detailed analysis and comparison results, see [../data_analyse/](../data_analyse/)
- This is an experimental setup for research purposes
