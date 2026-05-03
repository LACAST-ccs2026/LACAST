# Constraint-Aware SQL Generator

> **Note**: This tool is provided as an executable JAR artifact for reproducibility and rapid adoption. The implementation is fully functional and ready for testing database management systems.

## 🚀 Quick Start

### Prerequisites
- **Java** (JDK 8+)
- **Python** (3.6+)

### Get SQL in 3 Steps

**1. Start Server**
```bash
java -jar SQLCraft-1.0.jar configs/mysql/config.json
```

**2. Connect Client**
```bash
python client.py
```

**3. Generate SQL**
```
> test: query 0 5
```

---

## 📖 Basic Configuration

### Customize Tables

Edit `configs/mysql/schema/1.json`:

```json
[
  {
    "key": "your_table_name",
    "fields": ["col1", "col2", "col3"],
    "types": ["integer", "text", "datetime"]
  }
]
```

### Change SQL Quantity

Modify the last number in the command:
```
test: query 0 10    # Generate 10 SQL statements
test: query 0 100   # Generate 100 SQL statements
```

### Server Configuration

- **Config path**: Required (e.g., `configs/mysql/config.json`)
- **Port**: Optional, default is `4619`

```bash
java -jar SQLCraft-1.0.jar configs/mysql/config.json        # Uses port 4619
java -jar SQLCraft-1.0.jar configs/mysql/config.json 5000   # Uses port 5000
```

---

## 🔧 Advanced Usage

### Command Modes

#### Test Mode
```
test: query 0 10
```
- `query`: Non-terminal symbol name from grammar
- `0`: Prefer the first derivation rule of `query`
- `10`: Number of SQL statements to generate

#### Learn Mode
```
learn: query 0 10
```
- `query 0`: Forces `query` to always use its first derivation rule
- Used for learning specific rule patterns

#### Learn with Feedback Mode
```
learnR: query 0 10
```
- Similar to `learn:` mode
- Returns `yes` when generated SQL contains rules from `recordRules.log`
- Useful for interactive rule learning

### Response Format

**Normal response:**
```
SELECT SUBTIME( TIMESTAMPADD( MINUTE...
SELECT IFNULL( IFNULL( NOW()...
WITH tom1 AS ( SELECT VAR_SAMP...
END
```

**LearnR mode with recorded rule:**
```
SELECT FROM_UNIXTIME( tom5.c0 )...
yes
WITH tom1 AS ( SELECT ADDDATE...
yes
END
```

## 📁 Project Structure

```
configs/mysql/
├── config.json              # Main configuration
├── datatypes/               # Data type definitions
│   ├── types.json
│   └── *.g4
├── grammars/
│   ├── grammar.g4           # SQL grammar rules
│   └── recordRules.log      # Learned rules
└── schema/
    └── 1.json               # Database schema
```

## 🎯 Configuration Details

### config.json

Configuration file that specifies paths, parameters, and generation settings. See `configs/mysql/config.json` for example.

### Schema Format (1.json)

Define your database tables:
```json
[
  {
    "key": "table_name",
    "fields": ["column1", "column2", ...],
    "types": ["type1", "type2", ...]
  }
]
```

### Grammar File (grammar.g4)

The complete ANTLR-style grammar file that defines SQL generation rules.

The grammar includes:
- **Base grammar** — SELECT, FROM, WHERE, GROUP BY, ORDER BY, subqueries, set operations, joins, CTEs, etc.
- **Datatype evaluators** — one per supported SQL type (e.g., `integer_evaluator`, `text_evaluator`)
- **Feature rules** — function and operator definitions
- **Constant productions** — keyword constants (e.g., `DISTINCT`, `ASC`, `DESC`)

### Configuration Parameters

Key parameters in `config.json`:
- `depth`: Maximum recursion depth
- `GB_UNIFIED_RULE`: Unified GROUP BY rule
- `AGG_ONLY_IN_GB`: Restrict aggregates to GROUP BY
- `OUTER_REF_ENABLED`: Enable outer references

---

## 🧪 Testing

```bash
# Terminal 1: Start server (default port 4619)
java -jar SQLCraft-1.0.jar configs/mysql/config.json

# Terminal 2: Run client
python client.py

# Commands
> test: query 0 5
> learn: query 0 5
> learnR: query 0 5
> exit
```

---

## ⚠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| Connection refused | Check if server is running and port is available |
| No SQL generated | Verify grammar file path and schema JSON format |
| Java version error | Use JDK 8 or higher |

---

## 🔍 Technical Details

### Grammar Rule Selection

- **test:** mode selects rules based on probability + test preference
- **learn:** mode forces specific rule selection
- **learnR:** mode provides feedback on learned rules

### Recursion Depth

Controlled by `depth` parameter in config.json to prevent infinite recursion.

Data types defined in `datatypes/` directory control value generation for different SQL types.

---

## License

Educational and testing purposes only.
