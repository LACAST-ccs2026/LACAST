#!/bin/bash
set -e

echo "[step-1] set environment variables..."

SQLITE_VERSION="3510300"
SOURCE_DIR="/app/dbms/sqlite-autoconf-$SQLITE_VERSION"
INSTALL_DIR="/usr/local/sqlite-$SQLITE_VERSION"

echo "[step-1] finish!"

echo "[step-2] remove gcov runtime files..."

find $SOURCE_DIR -name "*.gcda" -delete || true
find $SOURCE_DIR -name "*.gcov" -delete || true

echo "[step-2] finish!"

echo "[step-3] reset lcov counters..."

lcov --directory $SOURCE_DIR --zerocounters

echo "[step-3] finish!"

echo "[step-4] execute simple SQL to trigger coverage..."

# 使用安装的 sqlite3 执行简单语句，触发 .gcda 文件生成
if [ -f "$INSTALL_DIR/bin/sqlite3" ]; then
    echo "SELECT 1;" | $INSTALL_DIR/bin/sqlite3 2>/dev/null || true
    echo "Coverage data triggered."
else
    echo "WARNING: sqlite3 binary not found at $INSTALL_DIR/bin/sqlite3"
fi

echo "[step-4] finish!"

echo "[done] SQLite coverage has been reset."