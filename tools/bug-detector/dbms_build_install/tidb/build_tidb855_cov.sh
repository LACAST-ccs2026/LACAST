#!/bin/bash
set -e

echo "[step-1] install dependencies..."

mkdir -p /app/dbms/
cd /app/dbms/

apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    build-essential

echo "[step-1] finish!"


echo "[step-2] install Go..."

if ! command -v go &> /dev/null; then
    wget https://go.dev/dl/go1.25.5.linux-amd64.tar.gz
    tar -C /usr/local -xzf go1.25.5.linux-amd64.tar.gz
fi

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

go version

echo "[step-2] finish!"


echo "[step-3] set environment variables..."

export TIDB_VERSION="v8.5.5"
export SOURCE_DIR="/app/dbms/tidb-8.5.5"
export COVER_DIR="/tmp/tidb/cov"
export DATA_DIR="/tmp/tidb/data"
export PORT=${PORT:-4000}
export STATUS_PORT=${STATUS_PORT:-10080}

echo "[step-3] finish!"


echo "[step-4] download TiDB source..."

cd /app/dbms

if [ ! -d "$SOURCE_DIR" ]; then
    git clone --branch $TIDB_VERSION https://github.com/pingcap/tidb.git tidb-8.5.5
fi

echo "[step-4] finish!"


echo "[step-5] prepare dependencies..."

cd $SOURCE_DIR
go env -w GOPROXY=https://goproxy.cn,direct
go mod tidy

echo "[step-5] finish!"


echo "[step-6] prepare directories..."

mkdir -p $COVER_DIR
rm -rf $DATA_DIR
mkdir -p $DATA_DIR

echo "[step-6] finish!"


echo "[step-7] build tidb (with coverage)..."

cd $SOURCE_DIR

export GOCOVERDIR=$COVER_DIR

go build -cover -covermode=atomic -coverpkg=./... -o bin/tidb-server ./cmd/tidb-server

echo "[step-7] finish!"


echo "[step-8] start tidb server..."

# 清理端口
fuser -k ${PORT}/tcp || true
fuser -k ${STATUS_PORT}/tcp || true

cd $SOURCE_DIR

GOCOVERDIR=$COVER_DIR ./bin/tidb-server \
    --store=unistore \
    --path=$DATA_DIR \
    -P $PORT \
    --status=$STATUS_PORT \
    --host=0.0.0.0 \
    -L error \
    > /tmp/tidb.log 2>&1 &

PID=$!

sleep 5

echo "[step-8] check tidb status..."

if ! ps -p $PID > /dev/null; then
    echo "[ERROR] TiDB failed to start!"
    echo "===== TiDB LOG ====="
    tail -n 50 /tmp/tidb.log
    exit 1
fi

if ss -lnt | grep -q ":${PORT}"; then
    echo "TiDB is running (port: ${PORT})"
else
    echo "[ERROR] TiDB port not listening!"
    tail -n 50 /tmp/tidb.log
    exit 1
fi

echo "[step-8] finish!"


echo "[step-9] initialize database (set root password + create test db)..."

# 等待服务 ready
for i in {1..10}; do
    if timeout 1 bash -c "</dev/tcp/127.0.0.1/${PORT}" 2>/dev/null; then
        break
    fi
    sleep 1
done

# 安装 mysql client（如果没有）
if ! command -v mysql &> /dev/null; then
    echo "[info] installing mysql client..."
    apt-get update && apt-get install -y default-mysql-client
fi

# 初始化 SQL
mysql -h 127.0.0.1 -P $PORT -u root <<EOF

ALTER USER 'root'@'%' IDENTIFIED BY '123456';

CREATE DATABASE IF NOT EXISTS test;

EOF

echo "[step-9] finish!"


echo "[step-10] verify login..."

if mysql -h 127.0.0.1 -P $PORT -u root -p123456 -e "SHOW DATABASES;" > /dev/null 2>&1; then
    echo "Login verification passed"
else
    echo "[ERROR] Login verification failed"
    exit 1
fi

echo "[step-10] finish!"


echo ""
echo "[done] TiDB build & start completed"
echo ""
echo "TiDB running at:"
echo "  host: 127.0.0.1"
echo "  port: $PORT"
echo ""
echo "coverage dir:"
echo "  $COVER_DIR"
echo ""
echo "log file:"
echo "  /tmp/tidb.log"
