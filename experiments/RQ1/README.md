# RQ1 Experiment Code

This repository contains the analysis code for Research Question 1 (RQ1) of our SQL generation tools study.

## Demo Data Note

The provided dataset is a **demo subset** representing approximately 1 second of SQL generation (sampling ratio: 1/86400 = 1/(60×60×24)) from our full 24-hour experiment. 

**Why demo data?**
- Full dataset size: **over 100GB** (24-hour experiment)
- Demo dataset size: ~6MB (1-second sample)
- **You can easily generate the full dataset using the tools referenced below**

**Tool References:**
- LACAST: [`../../tools/bug-detector/`](../../tools/bug-detector/)
- SQLancer: [https://github.com/sqlancer/sqlancer](https://github.com/sqlancer/sqlancer)
- PINOLO: [https://github.com/qaqcatz/impomysql](https://github.com/qaqcatz/impomysql)

## Quick Start

### Requirements

- Python 3.7+
- Required packages: matplotlib, numpy, scipy

```bash
pip install matplotlib numpy scipy
```

### Run Analysis

Execute the complete analysis pipeline with one command:

```bash
python run_analysis.py
```

This will automatically:
1. Process SQL queries from input dataset
2. Calculate performance metrics
3. Generate visualization charts

## Input & Output

### Input

Location: `input_dataset/`

Each tool directory contains JSONL files with SQL queries:
```
input_dataset/
├── LACAST/
│   ├── mariadb/epoch-1.jsonl
│   ├── mysql/epoch-1.jsonl
│   ├── postgresql/epoch-1.jsonl
│   ├── sqlite/epoch-1.jsonl
│   └── tidb/epoch-1.jsonl
├── PINOLO/
│   ├── mariadb/epoch-1.jsonl
│   ├── mysql/epoch-1.jsonl
│   └── tidb/epoch-1.jsonl
└── SQLancer/
    ├── mariadb/epoch-1.jsonl
    ├── mysql/epoch-1.jsonl
    ├── postgresql/epoch-1.jsonl
    ├── sqlite/epoch-1.jsonl
    └── tidb/epoch-1.jsonl
```

Input format (JSONL):
```json
{"sql": "SELECT * FROM table1", "result": "success", "error_info": ""}
```

### Output

After running the analysis, you will find:

**1. Performance Metrics** - `output/metrics_final.csv`

| Column | Description |
|--------|-------------|
| DB | Database type |
| Tool | SQL generation tool |
| Correctness_Avg | Average correctness (%) |
| Unique_Tokens | Average unique tokens per query |
| Total_Unique_Tokens | Total unique tokens globally |
| Generated_SQL_per_sec | Number of queries generated per second |
| Token_Throughput_per_sec | Total tokens generated per second |

**2. Visualization** - `output/charts/rq1_results.pdf`

Combined chart showing token diversity vs correctness for all databases:
- Row 1: mysql, mariadb, sqlite
- Row 2: legend, postgresql, tidb

**Important:** Due to the small sample size of demo data, there may be deviations from the full experiment results, especially for global metrics like `Total Unique Tokens`. These metrics accumulate across the entire dataset, so smaller samples naturally show lower diversity.

**Errata:** If you noticed that the `Token Throughput` values in this demo differ from those in the paper, we sincerely apologize. In the paper, we incorrectly labeled this metric as "tokens/s" when it should have been "tokens/hour". The correct unit is **tokens/hour**.

## Project Structure

```
RQ1/
├── input_dataset/              # Input data (demo)
│   ├── LACAST/                 # LACAST: supports all 5 databases
│   ├── PINOLO/                 # PINOLO: supports 3 databases (mariadb, mysql, tidb)
│   └── SQLancer/               # SQLancer: supports all 5 databases
│
├── processed_results/          # Intermediate results
│   ├── LACAST/
│   │   └── [db]/
│   │       ├── data_summary.txt    # Per-query token analysis
│   │       ├── error_summary.txt   # Error messages
│   │       └── summary.txt         # Aggregate statistics
│   ├── PINOLO/
│   └── SQLancer/
│
├── output/                     # Final outputs
│   ├── metrics_final.csv       # Performance metrics table
│   ├── plot_data/              # Data for visualization
│   └── charts/
│       └── rq1_results.pdf     # Combined visualization
│
├── scripts/                    # Processing scripts
│   ├── 1_process_all.py        # Process all tools' data with unified token categorization
│   ├── 2_calculate_metrics.py  # Calculate performance metrics
│   ├── 3_prepare_plot_data.py  # Prepare data for plotting
│   ├── 4_draw_combined_chart.py # Generate combined chart
│   └── token_categories.py     # Unified SQL keywords and token categories
│
└── run_analysis.py             # Main entry point
```

## Analysis Pipeline

The analysis consists of 4 steps:

1. **Token Analysis** (`1_process_all.py`)
   - Process SQL queries from all tools (LACAST, PINOLO, SQLancer) with unified token categorization
   - **Note:** We identify unique SQL features as token types (e.g., `SELECT`, `WHERE` as separate tokens), while applying pattern matching for variables (e.g., `t0`, `t1` → `TABLE_REFS`). This measures token diversity rather than raw count.

2. **Metrics Calculation** (`2_calculate_metrics.py`)
   - Compute correctness rate
   - Calculate throughput metrics
   - Generate summary table

3. **Plot Data Preparation** (`3_prepare_plot_data.py`)
   - Organize data by database
   - Prepare for visualization

4. **Chart Generation** (`4_draw_combined_chart.py`)
   - Create combined visualization
   - Generate PDF output

## Reproducibility

To reproduce the full experiment with your own data:

1. Prepare your dataset in the same JSONL format. You can directly copy the output from `tools/bug-detector/data/{dbms}/normal/record/` to `input_dataset/`
2. Place files in `input_dataset/[TOOL]/[DB]/epoch-1.jsonl`
3. Run `python run_analysis.py`
4. Check results in `output/`

## Generated

- Date: 2026-05-01
