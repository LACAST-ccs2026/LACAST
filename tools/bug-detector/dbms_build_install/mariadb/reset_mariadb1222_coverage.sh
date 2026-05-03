#!/bin/bash
set -e

echo "[step-1] set environment variables..."

MARIADB_VERSION="12.2.2"
SOURCE_DIR="/app/dbms/mariadb-$MARIADB_VERSION"
BUILD_DIR="$SOURCE_DIR/build"

echo "[step-1] finish!"

echo "[step-2] stop MariaDB before reset..."

# 先正常停止，确保之前的覆盖率数据被写入（如果有的话）
INSTALL_DIR="/usr/local/mariadb1222"
SOCKET="/tmp/mariadb.sock"
if [ -S "$SOCKET" ]; then
    $INSTALL_DIR/bin/mariadb-admin -u root -p123456 --socket=$SOCKET shutdown 2>/dev/null || true
    sleep 3
fi
pkill -9 mariadbd 2>/dev/null || true
sleep 1

echo "[step-2] finish!"

echo "[step-3] remove gcov runtime files..."

# 删除所有运行时生成的 gcda 和 gcov 文件
find $SOURCE_DIR -name "*.gcda" -delete 2>/dev/null || true
find $SOURCE_DIR -name "*.gcov" -delete 2>/dev/null || true

echo "[step-3] finish!"

echo "[step-4] reset lcov counters..."

# 注意：lcov --zerocounters 需要在有 .gcda 文件的地方运行
# 如果 build 目录没有 gcda，这个命令可能无效
if [ -d "$BUILD_DIR" ]; then
    lcov --directory $BUILD_DIR --zerocounters 2>/dev/null || true
fi

echo "[step-4] finish!"

echo "[done] MariaDB coverage has been reset."
echo "You can now start MariaDB and run tests."