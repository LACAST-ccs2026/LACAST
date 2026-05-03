# RQ3: Contribution Evaluation of Components

This directory contains the setup and analysis code for evaluating the contribution of key components in LACAST.

## Overview

We evaluate the contribution of two key components:
- **Static Constraints**: Scope and type constraints in the grammar
- **Iterative Training Agent**: LLM-based rule refinement

## Directory Structure

```
RQ3/
├── setup_NoS/          # LACAST without Static Constraints
│   ├── README.md       # Setup instructions
│   ├── accuracy_test.py
│   └── ...
│
├── setup_NoI/          # LACAST without Iterative Training Agent
│   └── README.md       # Setup instructions
│
└── data_analyse/       # Analysis scripts and results
    ├── README.md       # Analysis instructions
    ├── run_analysis.py
    └── ...
```

## Quick Start

### 1. Run Setup Experiments

**Without Static Constraints (NoS):**
```bash
cd setup_NoS
python accuracy_test.py configs/sqlite.yaml
```

**Without Iterative Training (NoI):**
```bash
cd setup_NoI
# Follow instructions in README.md
```

### 2. Analyze Results

```bash
cd data_analyse
python run_analysis.py
```

See [data_analyse/README.md](data_analyse/README.md) for detailed analysis instructions and results.

## Configuration Descriptions

| Configuration | Description |
|---------------|-------------|
| **LACAST (Full)** | Complete system with both Static Constraints and Iterative Training Agent |
| **NoS** | Without Static Constraints, uses go-randgen with flat grammar rules |
| **NoI** | Without Iterative Training Agent, uses `--no-fix` flag in grammar-generator |

## Related Resources

- **RQ1**: Baseline LACAST performance - see [../RQ1/](../RQ1/)
- **LACAST Tool**: [../../tools/bug-detector/](../../tools/bug-detector/)
- **Grammar Generator**: [../../tools/grammar-generator/](../../tools/grammar-generator/)
