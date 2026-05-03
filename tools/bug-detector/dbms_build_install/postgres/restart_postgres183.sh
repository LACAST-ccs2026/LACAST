#!/bin/bash
set -e

echo "[step-1] set environment variables..."

PG_VERSION="18.3"

SOURCE_DIR="/app/dbms/postgresql-$PG_VERSION"
INSTALL_DIR="/usr/local/postgres183"
DATA_DIR="$SOURCE_DIR/data"

PORT="5432"

echo "[step-1] finish!"


echo "[step-2] stop postgres if running..."

sudo -u postgres $INSTALL_DIR/bin/pg_ctl \
-D $DATA_DIR \
stop || true

echo "[step-2] finish!"


echo "[step-3] ensure postgres processes are stopped..."

pkill -9 postgres || true

sleep 2

echo "[step-3] finish!"


echo "[step-4] start postgres..."

sudo -u postgres $INSTALL_DIR/bin/pg_ctl \
-D $DATA_DIR \
-o "-p $PORT" \
-l $DATA_DIR/logfile \
start

sleep 3

echo "[step-4] finish!"


echo "[step-5] check postgres status..."

sudo -u postgres $INSTALL_DIR/bin/pg_ctl \
-D $DATA_DIR \
status

echo "[step-5] finish!"


echo "[done] PostgreSQL $PG_VERSION restarted successfully."
