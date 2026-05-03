#!/bin/bash
set -e

echo "[step-1] set environment variables..."

PG_VERSION="18.3"
SOURCE_DIR="/app/dbms/postgresql-$PG_VERSION"

echo "[step-1] finish!"


echo "[step-2] remove gcov runtime files..."

find $SOURCE_DIR -name "*.gcda" -delete || true
find $SOURCE_DIR -name "*.gcov" -delete || true

echo "[step-2] finish!"


echo "[step-3] reset lcov counters..."

lcov --directory $SOURCE_DIR --zerocounters

echo "[step-3] finish!"


echo "[done] PostgreSQL coverage has been reset."
