# RQ2: Bug Detection with LACAST

This repository contains the bug detection results using LACAST and its variants.

## Overview

LACAST can be used to automatically detect bugs in database management systems (DBMS) by generating complex SQL queries and comparing execution results across different database implementations.

## Bug Detection Methods

We used two methods to discover bugs:

1. **LACAST alone** - Original LACAST tool generating diverse SQL queries
2. **LACAST+RADAR** - LACAST enhanced with RADAR for differential testing

## Results Summary

### Table 3: Real-World Unique Bugs Discovered by LACAST Alone

| DBMS | Reported | Confirmed | Not a Bug |
|------|----------|-----------|-----------|
| MySQL | 4 | 3 | 0 |
| MariaDB | 13 | 13 | 0 |
| PostgreSQL | 1 | 1 | 0 |
| TiDB | 8 | 8 | 0 |
| **Total** | **26** | **25** | **0** |

### Table 4: Bugs Discovered by LACAST+RADAR

| DBMS | Reported | Confirmed | Not a Bug |
|------|----------|-----------|-----------|
| MySQL | 11 | 11 | 0 |
| MariaDB | 8 | 6 | 2 |
| TiDB | 11 | 11 | 0 |
| **Total** | **30** | **28** | **2** |

## Bug List

The [BugList.md](./BugList.md) in this directory provides a detailed view of the bug reports, expanding on the summary information in [../../BugList.md](../../BugList.md).

For the complete bug list with all details (URL, type, status, discovery method), see:
- **[./BugList.md](./BugList.md)** - Detailed bug list for RQ2
- **[../../BugList.md](../../BugList.md)** - Complete project-wide bug list

## Reproducibility

### Run Bug Detector

To reproduce the bug detection process:

1. **LACAST Setup**: Refer to [`../../tools/bug-detector/`](../../tools/bug-detector/) for installation and configuration
2. **RADAR Integration**: Refer to [https://github.com/tcse-iscas/radar](https://github.com/tcse-iscas/radar) for differential testing setup
3. **Execution**: Run LACAST with appropriate parameters for each target DBMS

### Other Tool Experiments

For comparison and reference, we also conducted experiments with other SQL generation tools:

- **SQLancer**: Refer to [https://github.com/sqlancer/sqlancer](https://github.com/sqlancer/sqlancer) for the baseline experiment
- **PINOLO**: Refer to [https://github.com/qaqcatz/impomysql](https://github.com/qaqcatz/impomysql) for the baseline experiment
- **SQLancer+RADAR**: Refer to [https://github.com/tcse-iscas/radar](https://github.com/tcse-iscas/radar) for the enhanced differential testing experiment

### Output Logs

The raw output logs from bug detection runs are stored in:
- **Log Path**: `tools/bug-detector/data/{dbms}/normal/record/`


## Bug Categories

The discovered bugs fall into the following categories:

- **Logic bugs**: Incorrect query results or unexpected behavior
- **Crash bugs**: System crashes or assertion failures

## Coverage Data

We do not include the coverage data in this repository due to the large file sizes across different tools and databases.

However, you can generate coverage data using the following methods:

### For MySQL, MariaDB, SQLite, and PostgreSQL

Use **gcov** to measure code coverage:

```bash
# Compile with coverage flags
gcc -fprofile-arcs -ftest-coverage -o your_program source.c

# Run your tests
./your_program

# Generate coverage report
gcov source.c
```

For detailed usage, refer to the [gcov documentation](https://gcc.gnu.org/onlinedocs/gcc/Gcov.html).

### For TiDB

TiDB is written in Go and provides built-in coverage tools:

```bash
# Run tests with coverage
go test -coverprofile=coverage.out ./...

# View coverage by function
go tool cover -func=coverage.out

# Generate HTML coverage report
go tool cover -html=coverage.out -o coverage.html
```

For more details, see the [Go coverage documentation](https://blog.golang.org/cover).

## Impact

All confirmed bugs have been reported to the respective DBMS development teams:
- MySQL: [MySQL Bug Database](https://bugs.mysql.com/)
- MariaDB: [MariaDB JIRA](https://jira.mariadb.org/)
- PostgreSQL: [PostgreSQL Mailing List](https://www.postgresql.org/list/)
- TiDB: [TiDB GitHub Issues](https://github.com/pingcap/tidb/issues)


