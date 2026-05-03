
#!/bin/bash
set -e

MYSQL_VERSION="8.4.8"

SOURCE_DIR="/app/dbms/mysql-$MYSQL_VERSION"
INSTALL_DIR="/usr/local/mysql848"
DATA_DIR="$SOURCE_DIR/data"
SOCKET_PATH="/tmp/mysql.sock"
TAR_FILE="/app/dbms/mysql-$MYSQL_VERSION.tar.gz"

echo "[step-1] stop running mysql if exists..."

# 尝试优雅关闭
if [ -S "$SOCKET_PATH" ]; then
    $INSTALL_DIR/bin/mysqladmin -u root -S $SOCKET_PATH shutdown || true
fi

# 强制终止 mysqld
pkill -9 mysqld || true

sleep 2

echo "[step-1] finish!"

echo "[step-2] remove installation directory..."

rm -rf $INSTALL_DIR

echo "[step-2] finish!"

echo "[step-3] remove source directory..."

rm -rf $SOURCE_DIR

echo "[step-3] finish!"

echo "[step-4] remove downloaded tar..."

rm -f $TAR_FILE

echo "[step-4] finish!"

echo "[step-5] remove runtime files..."

rm -f /tmp/mysql.sock
rm -f /tmp/mysql.sock.lock

echo "[step-5] finish!"

echo "[step-6] remove possible pid files..."

find /tmp -name "mysqld.pid" -delete || true

echo "[step-6] finish!"

echo "[done] MySQL $MYSQL_VERSION has been completely removed."
