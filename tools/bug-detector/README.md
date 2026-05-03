# Bug Detector

This tool uses LACAST for automated bug detection in database management systems (DBMS) by generating diverse SQL queries and detecting runtime errors.

## Requirements

### System Requirements
- Ubuntu 22.04 or similar Linux system
- Python 3.10+
- Java 17+
- Docker (for MySQL, MariaDB, PostgreSQL, TiDB)

### Python Dependencies
```bash
pip3 install apsw mysql-connector-python psycopg2-binary pyyaml rich
```

### Java Setup
```bash
# Install Java 17
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk

# Verify version
java -version  # Should show 17.x.x
```

## Database Setup

### MySQL
```bash
docker run -d --name mysql8 \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -p 3306:3306 \
  mysql:8.4

# Test connection
mysql -h 127.0.0.1 -P 3306 -u root -p123456 -e "SELECT 1"
```

### MariaDB
```bash
docker run -d --name mariadb \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -p 3307:3306 \
  mariadb:12.2

# Test connection
mysql -h 127.0.0.1 -P 3307 -u root -p123456 -e "SELECT 1"
```

### PostgreSQL
```bash
docker run -d --name postgres \
  -e POSTGRES_PASSWORD=123456 \
  -p 15432:5432 \
  postgres:18

# Test connection
PGPASSWORD=123456 psql -h 127.0.0.1 -p 15432 -U postgres -c "SELECT 1"
```

### TiDB
```bash
docker run -d --name tidb \
  -p 4000:4000 \
  pingcap/tidb:v8.5.5

# Test connection (no password by default)
mysql -h 127.0.0.1 -P 4000 -u root -e "SELECT 1"
```

### SQLite
SQLite does not require a container. It is accessed directly via Python's `apsw` library.

## Configuration

If you modify the database installation method or container names, you need to update the following files:

1. **configs/dbms/normal/*.yml** - Database connection settings (host, port, username, password)
2. **new_dbms_driver.py** - Database driver implementation

### Debug and Coverage Build

For debug mode or coverage mode compilation and installation, refer to the scripts in `dbms_build_install/`:

```
dbms_build_install/
├── mysql/        # MySQL build scripts with coverage
├── mariadb/      # MariaDB build scripts with coverage
├── postgres/     # PostgreSQL build scripts with coverage
├── sqlite/       # SQLite build scripts with coverage
└── tidb/         # TiDB build scripts with coverage
```

Each directory contains scripts for building, installing, and collecting coverage data.

## Project Structure

```
bug-detector/
├── configs/                 # Configuration files
│   └── dbms/
│       ├── normal/         # Database configurations
│       └── radar/          # RADAR configurations
├── jar/                    # Java programs
│   ├── SQLCraft-1.0.jar    # SQL generator
│   ├── schema-generator.jar # Schema generator
│   └── configs/            # Java configurations
│
│   Note: sqlancer-2.0.0.jar is required for PostgreSQL testing.
│   Download from: https://github.com/sqlancer/sqlancer/releases
│   Place in jar/ directory before running PostgreSQL tests.
├── data/                   # Data directory
│   └── <db>/normal/        # Per-database data
│       ├── current_schema/ # Current schema
│       ├── default_schema/ # Default schema
│       └── logs/           # Logs
├── dbms_build_install/     # Build scripts for debug/coverage mode
├── normal_fuzz2.py         # Main program
├── new_dbms_driver.py      # Database driver
├── new_sql_generator.py    # SQL generator
├── schema_generator.py     # Schema generator
└── record.py              # Recorder
```

## Quick Start

### 1. Prepare Directories
```bash
# Create necessary directories
mkdir -p data/{mysql,mariadb,postgres,tidb,sqlite}/normal/{current_schema,default_schema,logs}

# Copy default schemas
cp jar/configs/*/schema/1.json data/*/normal/current_schema/converted_schema.json
cp jar/configs/*/schema/2.sql data/*/normal/current_schema/schema.sql
```

### 2. Run Fuzzing
```bash
# For SQLite
python3 normal_fuzz2.py sqlite

# For MySQL
python3 normal_fuzz2.py mysql

# For MariaDB
python3 normal_fuzz2.py mariadb

# For PostgreSQL
python3 normal_fuzz2.py postgres

# For TiDB
python3 normal_fuzz2.py tidb
```

## Configuration Files

### Database Configuration (configs/dbms/normal/*.yml)
```yaml
target_dbms: "mysql"
database_name: "sqlcraft"
schema_path: "./data/mysql/normal/current_schema/schema.sql"
max_connections: 1
db_config:
  host: "127.0.0.1"
  port: "3306"
  username: "root"
  password: "123456"
```

### SQL Generator Configuration (jar/configs/*/normal_configs_pve.json)
```json
{
  "typesJsonPath": "./jar/configs/sqlite/datatypes/types.json",
  "typesDir": "./jar/configs/sqlite/datatypes",
  "grammarPath": "./jar/configs/sqlite/grammars/grammar.g4",
  "schemaPath": "./data/sqlite/normal/current_schema/converted_schema.json",
  "startName": "query",
  "depth": 4
}
```

## Troubleshooting

### Docker Permission
If you encounter Docker permission issues:
```bash
sudo usermod -aG docker $USER
# Log out and log back in for changes to take effect
```

### Java Version
SQLCraft.jar requires Java 17+. If the version is incorrect:
```bash
sudo update-alternatives --config java
# Select java-17-openjdk
```

### Database Connection Failed
```bash
# Check container status
docker ps -a

# Start container
docker start <container_name>

# Check port
netstat -tlnp | grep <port>
```

### Java Program Errors
```bash
# Test SQLCraft.jar manually
java -jar jar/SQLCraft-1.0.jar jar/configs/sqlite/normal_configs_pve.json 10 0 5678

# Check schema files
ls -la data/*/normal/current_schema/
```

### Python Module Missing
```bash
pip3 install apsw mysql-connector-python psycopg2-binary pyyaml rich
```

## Notes

- Check logs at: `data/<db>/normal/logs/fuzz.log`
- Check container status: `docker ps -a`
- Check port usage: `netstat -tlnp`
- Verify Java version: `java -version`
