#!/bin/bash
set -e

echo "[step-1] install dependencies..."

mkdir -p /app/dbms/
cd /app/dbms/

apt-get update && apt-get install -y \
    build-essential \
    wget \
    curl \
    tar \
    lcov \
    gcovr

echo "[step-1] finish!"

echo "[step-2] set environment variables..."

export SQLITE_VERSION="3510300"
export TAR_NAME="sqlite-autoconf-${SQLITE_VERSION}.tar.gz"
export SOURCE_DIR="/app/dbms/sqlite-autoconf-${SQLITE_VERSION}"
export INSTALL_DIR="/usr/local/sqlite-${SQLITE_VERSION}"

echo "[step-2] finish!"

echo "[step-3] download sqlite source..."

if [ ! -f "$TAR_NAME" ]; then
    wget https://sqlite.org/2026/$TAR_NAME
fi

echo "[step-3] finish!"

echo "[step-4] extract source..."

if [ ! -d "$SOURCE_DIR" ]; then
    tar -xzf $TAR_NAME
fi

echo "[step-4] finish!"

echo "[step-5] configure build with coverage..."

cd $SOURCE_DIR

# 关键：gcov 编译参数
export CFLAGS="-fprofile-arcs -ftest-coverage -O0 -g"
export LDFLAGS="-fprofile-arcs -ftest-coverage -lgcov"

./configure \
    --prefix=$INSTALL_DIR \
    --disable-shared \
    --enable-static

echo "[step-5] finish!"

echo "[step-6] build sqlite..."

make -j$(nproc)

echo "[step-6] finish!"

echo "[step-7] install sqlite..."

make install

echo "[step-7] finish!"

echo "[step-8] verify build..."

$INSTALL_DIR/bin/sqlite3 --version

echo "[step-8] finish!"

echo ""
echo "[done] sqlite build with gcov completed"
echo ""
echo "binary location:"
echo "$INSTALL_DIR/bin/sqlite3"
