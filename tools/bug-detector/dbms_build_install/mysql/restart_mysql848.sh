#!/bin/bash
set -e

echo "[step-1] set environment variables..."

MYSQL_VERSION="8.4.8"
SOURCE_DIR="/app/dbms/mysql-$MYSQL_VERSION"
INSTALL_DIR="/usr/local/mysql848"
DATA_DIR="$SOURCE_DIR/data"
SOCKET_PATH="/tmp/mysql.sock"
USER="root"
PORT="3306"

# 请根据实际情况填写 root 密码
MYSQL_ROOT_PASSWORD="123456"

echo "[step-1] finish!"

echo "[step-2] stop mysql if running..."

# 优雅关闭
if [ -S "$SOCKET_PATH" ]; then
    $INSTALL_DIR/bin/mysqladmin -u $USER -p$MYSQL_ROOT_PASSWORD -S $SOCKET_PATH shutdown || true
fi

# 确保 mysqld 进程被结束
pkill -9 mysqld || true

sleep 2

echo "[step-2] finish!"

echo "[step-3] start mysql server..."

$INSTALL_DIR/bin/mysqld \
  --basedir=$INSTALL_DIR \
  --datadir=$DATA_DIR \
  --socket=$SOCKET_PATH \
  --port=$PORT \
  --bind-address=0.0.0.0 \
  --pid-file=$DATA_DIR/mysqld.pid \
  --user=$USER \
  --log-error=$DATA_DIR/error.log \
  --daemonize

sleep 5

echo "[step-3] finish!"

echo "[step-4] check mysql status..."

if [ -S "$SOCKET_PATH" ]; then
    echo "MySQL is running (socket exists: $SOCKET_PATH)"
else
    echo "MySQL is not running!"
fi

echo "[step-4] finish!"

echo "[done] MySQL $MYSQL_VERSION restarted successfully."
