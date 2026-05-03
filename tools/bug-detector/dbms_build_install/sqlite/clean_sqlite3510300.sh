#!/bin/bash
set -e

SQLITE_VERSION="3510300"

SOURCE_DIR="/app/dbms/sqlite-autoconf-${SQLITE_VERSION}"
INSTALL_DIR="/usr/local/sqlite-${SQLITE_VERSION}"
TAR_FILE="/app/dbms/sqlite-autoconf-${SQLITE_VERSION}.tar.gz"

echo "[step-1] stop running sqlite if exists..."

# SQLite 是嵌入式数据库，通常没有常驻进程
# 但如果有正在运行的测试进程，尝试终止
pkill -9 -f "sqlite3.*test" || true
pkill -9 -f "sqlite3.*fuzz" || true

sleep 1

echo "[step-1] finish!"

echo "[step-2] remove installation directory..."

rm -rf "$INSTALL_DIR"

echo "[step-2] finish!"

echo "[step-3] remove source directory..."

rm -rf "$SOURCE_DIR"

echo "[step-3] finish!"

echo "[step-4] remove downloaded tar..."

rm -f "$TAR_FILE"

echo "[step-4] finish!"

echo "[step-5] remove coverage runtime files..."

# 删除可能残留的 gcov 数据文件
find /app/dbms -name "*.gcda" -delete 2>/dev/null || true
find /app/dbms -name "*.gcno" -delete 2>/dev/null || true
find /app/dbms -name "*.gcov" -delete 2>/dev/null || true

echo "[step-5] finish!"

echo "[step-6] remove temporary test databases..."

# 删除测试可能创建的临时数据库文件
find /tmp -name "test*.db" -delete 2>/dev/null || true
find /tmp -name "*.sqlite" -delete 2>/dev/null || true
find /tmp -name "*.sqlite3" -delete 2>/dev/null || true

echo "[step-6] finish!"

echo "[done] SQLite $SQLITE_VERSION has been completely removed."