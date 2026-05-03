#!/bin/bash
set -e

echo "[step-1] set environment variables..."

SQLITE_VERSION="3510300"
INSTALL_DIR="/usr/local/sqlite-$SQLITE_VERSION"

echo "[step-1] finish!"

echo "[step-2] run sqlite to generate gcda..."

$INSTALL_DIR/bin/sqlite3 :memory: "SELECT 1;"

echo "[step-2] finish!"

echo "[step-3] check sqlite status..."

if [ $? -eq 0 ]; then
    echo "SQLite executed successfully (gcda should be generated)"
else
    echo "SQLite execution failed!"
fi

echo "[step-3] finish!"

echo "[done] SQLite $SQLITE_VERSION 'restart' (gcda generated) completed."