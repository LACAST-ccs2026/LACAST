#!/bin/bash
set -e

echo "[step-1] set environment variables..."

TIDB_VERSION="v8.5.5"

# 覆盖率目录（支持外部覆盖）
COVER_DIR=${COVER_DIR:-/tmp/tidb/cov}

echo "[step-1] finish!"

echo "[step-2] remove go coverage files..."

# 删除 GOCOVERDIR 下所有覆盖率数据（但保留目录本身）
if [ -d "$COVER_DIR" ]; then
    rm -rf ${COVER_DIR:?}/*
fi

echo "[step-2] finish!"

echo "[step-3] ensure directory exists..."

mkdir -p $COVER_DIR

echo "[step-3] finish!"

echo "[done] TiDB coverage has been reset."
