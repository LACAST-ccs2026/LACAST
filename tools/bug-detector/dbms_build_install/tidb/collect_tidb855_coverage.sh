#!/bin/bash

set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 OUTPUT_DIR"
    exit 1
fi

OUTPUT_DIR=$1

# ====== 覆盖率源目录（运行时产生）======
GOCOVER_DIR="/tmp/tidb/cov"

# ====== 输出目录 ======
SNAPSHOT_DIR="$OUTPUT_DIR/cov_snapshot"
MERGED_DIR="$OUTPUT_DIR/cov_merged"
OUT_FILE="$OUTPUT_DIR/cov_merged.out"

echo "[step-0] prepare directories..."

mkdir -p "$SNAPSHOT_DIR"
mkdir -p "$MERGED_DIR"

echo "[step-0] finish!"


echo "[step-1] copy coverage data (snapshot)..."

# ✅ 关键：从运行目录拷贝
cp -r "$GOCOVER_DIR"/* "$SNAPSHOT_DIR"/ 2>/dev/null || true

# 防止空目录
if [ -z "$(ls -A $SNAPSHOT_DIR 2>/dev/null)" ]; then
    echo "[ERROR] No coverage data found in $GOCOVER_DIR"
    exit 1
fi

echo "[step-1] finish!"


echo "[step-2] merge coverage data..."

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

go tool covdata merge \
    -i="$SNAPSHOT_DIR" \
    -o="$MERGED_DIR"

echo "[step-2] finish!"


echo "[step-3] convert to .out format..."

go tool covdata textfmt \
    -i="$MERGED_DIR" \
    -o="$OUT_FILE"

echo "[step-3] finish!"


echo "[done] coverage .out generated at: $OUT_FILE"
