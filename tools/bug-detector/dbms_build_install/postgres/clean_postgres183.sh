#!/bin/bash
set -e

echo "[step-1] set environment variables..."

export PG_VERSION="18.3"
export SOURCE_DIR="/app/dbms/postgresql-$PG_VERSION"
export INSTALL_DIR="/usr/local/postgres183"
export DATA_DIR="$SOURCE_DIR/data"
export PORT="5433"

# postgres 系统用户密码
export POSTGRES_PASSWORD=""

echo "[step-1] finish!"


echo "[step-2] stop postgres if running..."

echo "$POSTGRES_PASSWORD" | sudo -S -u postgres bash <<EOF

set -e

INSTALL_DIR="$INSTALL_DIR"
DATA_DIR="$DATA_DIR"

if [ -d "\$DATA_DIR" ]; then
    \$INSTALL_DIR/bin/pg_ctl -D \$DATA_DIR stop || true
fi

EOF

sleep 2

echo "[step-2] finish!"


echo "[step-3] kill possible postgres processes..."

pkill -9 postgres || true

echo "[step-3] finish!"


echo "[step-4] remove installation directory..."

rm -rf $INSTALL_DIR

echo "[step-4] finish!"


echo "[step-5] remove source directory..."

rm -rf $SOURCE_DIR

echo "[step-5] finish!"


echo "[step-6] remove downloaded tar..."

rm -f /app/dbms/postgresql-$PG_VERSION.tar.gz

echo "[step-6] finish!"


echo "[step-7] remove runtime files..."

rm -f /tmp/.s.PGSQL.$PORT || true
rm -f /tmp/.s.PGSQL.$PORT.lock || true

echo "[step-7] finish!"


echo "[step-8] remove possible pid files..."

find /tmp -name "postmaster.pid" -delete || true

echo "[step-8] finish!"


echo "[done] PostgreSQL $PG_VERSION has been completely removed."
