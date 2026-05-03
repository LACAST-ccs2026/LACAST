#!/bin/bash
set -e

echo "[step-1] set environment variables..."

VERSION="mariadb-12.2.2"
SOURCE_DIR="/app/dbms/mariadb-12.2.2"
INSTALL_DIR="/usr/local/mariadb1222"
DATA_DIR="$SOURCE_DIR/data"
SOCKET_PATH="/tmp/mariadb.sock"
USER="root"
PORT="3307"
MARIADB_ROOT_PASSWORD="123456"

echo "[step-1] finish!"

echo "[step-2] stop MariaDB if running..."

# 使用 socket 正常停止 MariaDB（发送 SIGTERM）
if [ -S "$SOCKET_PATH" ]; then
    $INSTALL_DIR/bin/mariadb-admin \
        -u $USER \
        -p$MARIADB_ROOT_PASSWORD \
        --socket=$SOCKET_PATH shutdown 2>/dev/null || true
    sleep 3
fi

# 检查是否已停止
if pgrep -x "mariadbd" > /dev/null 2>&1; then
    echo "Warning: MariaDB still running, waiting..."
    sleep 5
fi

# 最后的保险：强制杀死（会丢失覆盖率，所以尽量避免走到这一步）
pkill -9 mariadbd 2>/dev/null || true
sleep 1

echo "[step-2] finish!"

echo "[step-3] start MariaDB server..."

# 后台启动 MariaDB（不使用 --skip-grant-tables，保持与 build 脚本一致）
$INSTALL_DIR/bin/mariadbd \
    --no-defaults \
    --console \
    --port=$PORT \
    --datadir=$DATA_DIR \
    --user=root \
    --socket=$SOCKET_PATH \
    --bind-address=127.0.0.1 \
    --pid-file=$DATA_DIR/mariadb.pid \
    --log-error=$DATA_DIR/error.log &

# 等待 MariaDB 完全启动
for i in {1..30}; do
    if [ -S "$SOCKET_PATH" ]; then
        if $INSTALL_DIR/bin/mariadb-admin --socket=$SOCKET_PATH ping > /dev/null 2>&1; then
            echo "MariaDB is ready!"
            break
        fi
    fi
    sleep 1
done

if ! [ -S "$SOCKET_PATH" ]; then
    echo "MariaDB failed to start!"
    cat $DATA_DIR/error.log
    exit 1
fi

echo "[step-3] finish!"

echo "[step-4] trigger coverage generation..."

# 执行简单 SQL，确保 gcov 收到运行覆盖率
$INSTALL_DIR/bin/mariadb \
    -u $USER \
    -p$MARIADB_ROOT_PASSWORD \
    -h 127.0.0.1 \
    -P $PORT \
    -e "SELECT 1;"

echo "[step-4] finish!"

echo "[done] MariaDB ($VERSION) restarted successfully and coverage triggered."
echo "IMPORTANT: To collect coverage, run collect script which will gracefully stop MariaDB first."