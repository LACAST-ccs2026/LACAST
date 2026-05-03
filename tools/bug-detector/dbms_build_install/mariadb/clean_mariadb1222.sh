#!/bin/bash
set -e

echo "[step-1] set variables..."

VERSION="mariadb-12.2.2"
BASE_DIR="/app/dbms"
SOURCE_DIR="$BASE_DIR/mariadb-12.2.2"
BUILD_DIR="$SOURCE_DIR/build"
INSTALL_DIR="/usr/local/mariadb1222"
DATA_DIR="$SOURCE_DIR/data"
PORT="3307"
SOCKET="/tmp/mariadb.sock"

echo "[step-1] finish!"

echo "[step-2] stop running mariadb if exists..."

# ✅ 优雅关闭（保证 gcda 写入）
if [ -S "$SOCKET" ]; then
    $INSTALL_DIR/bin/mariadb-admin \
        -u root \
        --socket=$SOCKET shutdown || true
fi

sleep 2

# 尝试正常停止
pkill mariadbd || true
sleep 2

# 强制兜底
pkill -9 mariadbd || true

echo "[step-2] finish!"

echo "[step-3] remove installation directory..."

rm -rf "$INSTALL_DIR"

echo "[step-3] finish!"

echo "[step-4] remove data directory..."

rm -rf "$DATA_DIR"

echo "[step-4] finish!"

echo "[step-5] remove build directory..."

rm -rf "$BUILD_DIR"

echo "[step-5] finish!"

echo "[step-6] remove source directory..."

rm -rf "$SOURCE_DIR"

echo "[step-6] finish!"

echo "[step-7] remove runtime files..."

rm -f "$SOCKET"
rm -f "$SOCKET.lock"

echo "[step-7] finish!"

echo "[step-8] remove possible pid files..."

find /tmp -name "mariadb*.pid" -delete || true
find /tmp -name "mysqld*.pid" -delete || true

echo "[step-8] finish!"

echo "[step-9] remove logs (optional)..."

rm -f "$DATA_DIR/error.log" || true
rm -f "$DATA_DIR/stdout.log" || true

echo "[step-9] finish!"

echo "[step-10] remove coverage files (optional)..."

find "$SOURCE_DIR" -name "*.gcda" -delete 2>/dev/null || true
find "$SOURCE_DIR" -name "*.gcno" -delete 2>/dev/null || true

echo "[step-10] finish!"

echo ""
echo "[done] MariaDB ($VERSION) environment cleaned"