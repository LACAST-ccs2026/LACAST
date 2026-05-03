#!/bin/bash
set -e

TIDB_VERSION="v8.5.5"

SOURCE_DIR="/app/dbms/tidb-8.5.5"
COVER_DIR="/tmp/tidb/cov"
DATA_DIR="/tmp/tidb/data"
PORT="4000"
STATUS_PORT="10080"

echo "[step-1] stop running tidb if exists..."

# 优雅关闭（HTTP 接口）
curl -X POST http://127.0.0.1:${STATUS_PORT}/shutdown || true

# 强制终止 tidb-server
pkill -9 tidb-server || true

sleep 2

echo "[step-1] finish!"

echo "[step-2] remove source directory..."

rm -rf $SOURCE_DIR

echo "[step-2] finish!"

echo "[step-3] remove coverage directory..."

rm -rf $COVER_DIR

echo "[step-3] finish!"

echo "[step-4] remove data directory..."

rm -rf $DATA_DIR

echo "[step-4] finish!"

echo "[step-5] remove temporary tidb files..."

rm -rf /tmp/tidb

echo "[step-5] finish!"

echo "[step-6] clean possible ports..."

# 释放端口
fuser -k ${PORT}/tcp || true
fuser -k ${STATUS_PORT}/tcp || true

echo "[step-6] finish!"

echo "[done] TiDB $TIDB_VERSION has been completely removed."
