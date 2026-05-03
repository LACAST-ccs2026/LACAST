# LACAST

**L**LM-**A**ssisted Extension and **C**onstraint-**A**ware **S**QL Genera**t**ion for DBMS Testing

LACAST is an automated SQL generation tool for testing database management systems (DBMS). It combines constraint-aware SQL drafting with iterative training agents to generate diverse, correct, and bug-revealing SQL queries.

## Key Features

- **Multi-DBMS Support**: MySQL, MariaDB, PostgreSQL, SQLite, TiDB
- **High Correctness**: Generates syntactically and semantically correct SQL queries
- **Bug Detection**: Discovered 53+ confirmed bugs across major DBMSs

## Quick Start

### 1. Generate Grammar Rules

```bash
cd tools/grammar-generator
python main.py --dbms sqlite --work-dir workdirs/sqlite
```

See [tools/grammar-generator/README.md](tools/grammar-generator/README.md) for detailed usage.

### 2. Generate SQL Queries

```bash
cd tools/sql-gen
java -jar SQLCraft-1.0.jar configs/mysql/config.json
```

See [tools/sql-gen/README.md](tools/sql-gen/README.md) for detailed usage.

### 3. Detect Bugs

```bash
cd tools/bug-detector
python3 normal_fuzz2.py sqlite
```

See [tools/bug-detector/README.md](tools/bug-detector/README.md) for detailed usage.

### 4. Reproduce Experiments

Navigate to the experiments directory:
- [Preliminary Experiment](experiments/preliminary_experiment/): LLM-based SQL generation baseline
- [RQ1](experiments/RQ1/): Performance comparison with baseline tools
- [RQ2](experiments/RQ2/): Bug detection results
- [RQ3](experiments/RQ3/): Component contribution analysis

## Directory Structure

```
lacast-ccs2026-draft/
├── tools/                      # Executable tools and artifacts
│   ├── bug-detector/           # Bug detection tool using LACAST
│   ├── grammar-generator/      # SQL grammar extension tool
│   └── sql-gen/                # Constraint-aware SQL generator (JAR artifact)
│       ├── SQLCraft-1.0.jar    # Executable JAR
│       ├── client.py           # Python client
│       └── configs/            # Configuration files
│
├── experiments/                # Experimental results and analysis
│   ├── preliminary_experiment/ # Preliminary experiment: LLM-based SQL generation
│   ├── RQ1/                    # Performance comparison (LACAST vs SQLancer vs PINOLO)
│   ├── RQ2/                    # Bug detection results
│   └── RQ3/                    # Component contribution evaluation
│
├── BugList.md                  # Comprehensive list of discovered bugs
└── README.md                   # This file
```

## Tools Availability

All tools are provided as executable artifacts to ensure reproducibility:

- **sql-gen**: Provided as a ready-to-use JAR file for rapid adoption
- **Other tools**: Include source code for transparency and customization

See individual tool directories for detailed documentation.

## Related Tools

- **SQLancer**: [https://github.com/sqlancer/sqlancer](https://github.com/sqlancer/sqlancer)
- **PINOLO**: [https://github.com/qaqcatz/impomysql](https://github.com/qaqcatz/impomysql)
- **RADAR**: [https://github.com/tcse-iscas/radar](https://github.com/tcse-iscas/radar)

## License

This project is provided for educational and testing purposes only.
