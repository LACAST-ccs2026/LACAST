#!/bin/bash
set -e

echo "[step-1] set environment variables..."

TIDB_VERSION="v8.5.5"
SOURCE_DIR="/app/dbms/tidb-8.5.5"

PORT=${PORT:-4000}
STATUS_PORT=${STATUS_PORT:-10080}

DATA_DIR="/tmp/tidb/data"
COVER_DIR="/tmp/tidb/cov"
LOG_FILE="/tmp/tidb/tidb.log"

echo "[step-1] finish!"


echo "[step-2] stop tidb if running..."

# 只有在端口存在时才尝试 shutdown
if ss -lnt | grep -q ":${STATUS_PORT}"; then
    echo "[info] try graceful shutdown..."
    curl -sf -X POST http://127.0.0.1:${STATUS_PORT}/shutdown || true
    sleep 2
fi

# 如果进程仍然存在 → 温和 kill
if pgrep tidb-server > /dev/null; then
    echo "[info] sending SIGTERM..."
    pkill -15 tidb-server || true
    sleep 3
fi

# 如果还没死 → 强杀
if pgrep tidb-server > /dev/null; then
    echo "[info] force killing..."
    pkill -9 tidb-server || true
    sleep 2
fi

echo "[step-2] finish!"


echo "[step-3] wait for ports to be released..."

for i in {1..10}; do
    if ! ss -lnt | grep -q ":${PORT}" && ! ss -lnt | grep -q ":${STATUS_PORT}"; then
        break
    fi
    sleep 1
done

echo "[step-3] finish!"


echo "[step-4] prepare directories..."

mkdir -p $DATA_DIR
mkdir -p $COVER_DIR

echo "[step-4] finish!"


echo "[step-5] start tidb server with coverage..."

cd $SOURCE_DIR

export GOCOVERDIR=$COVER_DIR

./bin/tidb-server \
  --store=unistore \
  --path=$DATA_DIR \
  --host=0.0.0.0 \
  -P $PORT \
  --status=$STATUS_PORT \
  -L error \
  > $LOG_FILE 2>&1 &

PID=$!

sleep 5

# 检查是否崩溃
if ! ps -p $PID > /dev/null; then
    echo "[ERROR] TiDB process exited!"
    echo "===== LOG ====="
    tail -n 50 $LOG_FILE
    exit 1
fi

echo "[step-5] finish!"


echo "[step-6] check tidb status..."

if ss -lnt | grep -q ":${PORT}"; then
    echo "TiDB is running (port: ${PORT})"
else
    echo "[ERROR] TiDB port not listening!"
    tail -n 50 $LOG_FILE
    exit 1
fi

if ss -lnt | grep -q ":${STATUS_PORT}"; then
    echo "Status API is running (port: ${STATUS_PORT})"
else
    echo "[WARNING] Status API not running"
fi

echo "[step-6] finish!"


echo "[done] TiDB $TIDB_VERSION restarted successfully."
