# LACAST without Iterative Training Agent (NoI)

This directory explains how to run LACAST without the Iterative Training Agent.

> **Note**: The actual implementation is integrated into the grammar-generator tool. This directory only provides usage instructions.

## What is NoI?

When running in NoI mode, the grammar generator skips the LLM-based rule repair step. Failed rules are discarded immediately without attempting to fix them.

## How to Run

Use the `--no-fix` flag when running the grammar-generator:

```bash
cd ../../../tools/grammar-generator/

python main.py --dbms <dbms> --work-dir <work_dir> --no-fix
```

### Examples

```bash
# For SQLite
python main.py --dbms sqlite --work-dir workdirs/sqlite --no-fix

# For MySQL
python main.py --dbms mysql --work-dir workdirs/mysql --no-fix

# For PostgreSQL
python main.py --dbms postgres --work-dir workdirs/postgres --no-fix

# For MariaDB
python main.py --dbms mariadb --work-dir workdirs/mariadb --no-fix

# For TiDB
python main.py --dbms tidb --work-dir workdirs/tidb --no-fix
```

## Parameters

| Parameter | Description |
|-----------|-------------|
| `--dbms` | Target DBMS (sqlite, mysql, mariadb, postgres, tidb) |
| `--work-dir` | Working directory for the DBMS |
| `--no-fix` | Skip fix step - discard failed rules without LLM repair |
| `--limit` | Maximum features to train (0=unlimited) |
| `--timeout` | Timeout in minutes (0=unlimited) |

## Prerequisites

Before running, ensure you have:

1. **LLM API credentials** configured in `tools/grammar-generator/.env`:
   ```
   LLM_API_KEY=your-api-key
   LLM_BASE_URL=https://api.openai.com/v1
   LLM_MODEL=gpt-4
   ```

2. **Database connection** configured in `tools/grammar-generator/configs/dbms/<dbms>.yaml`

3. **Training corpus** prepared at `<work_dir>/web_corpus.json`

## Related Documentation

- **Grammar Generator**: [../../../tools/grammar-generator/](../../../tools/grammar-generator/)
- **Analysis Results**: [../data_analyse/](../data_analyse/)
