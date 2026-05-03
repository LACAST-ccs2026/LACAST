#!/bin/bash
set -e

echo "[step-1] set environment variables..."

MYSQL_VERSION="8.4.8"
SOURCE_DIR="/app/dbms/mysql-$MYSQL_VERSION"
BUILD_DIR="$SOURCE_DIR/build"

echo "[step-1] finish!"

echo "[step-2] remove gcov runtime files..."

#find $SOURCE_DIR -name "*.gcda" -delete || true
#find $SOURCE_DIR -name "*.gcov" -delete || true
find BUILD_DIR -name "*.gcda" -delete || true
find BUILD_DIR -name "*.gcov" -delete || true

echo "[step-2] finish!"

echo "[step-3] reset lcov counters..."

#lcov --directory $SOURCE_DIR --zerocounters
lcov --directory BUILD_DIR --zerocounters

echo "[step-3] finish!"

echo "[done] MySQL coverage has been reset."
