#!/bin/bash
set -e

echo "[step-1] set environment variables..."

PG_VERSION="18.3"

SOURCE_DIR="/app/dbms/postgresql-$PG_VERSION"
INSTALL_DIR="/usr/local/postgres183"
DATA_DIR="$SOURCE_DIR/data"

PORT="5433"

TAR_FILE="/app/dbms/postgresql-$PG_VERSION.tar.gz"
DOWNLOAD_URL="https://ftp.postgresql.org/pub/source/v$PG_VERSION/postgresql-$PG_VERSION.tar.gz"

echo "[step-1] finish!"


echo "[step-2] apt install and create base directory..."

apt-get update && apt-get install -y \
    build-essential \
    libreadline-dev \
    zlib1g-dev \
    flex \
    bison \
    libxml2-dev \
    libxslt1-dev \
    libssl-dev \
    libxml2-utils \
    xsltproc \
    ccache \
    pkg-config \
    lcov \
    gcovr \
    wget

mkdir -p /app/dbms

echo "[step-2] finish!"


echo "[step-3] download source..."

if [ ! -f "$TAR_FILE" ]; then
    wget -O $TAR_FILE $DOWNLOAD_URL
fi

echo "[step-3] finish!"


echo "[step-4] extract source if not exists..."

if [ ! -d "$SOURCE_DIR" ]; then
    tar -xzf $TAR_FILE -C /app/dbms
fi

echo "[step-4] finish!"


echo "[step-4.1] create data directory..."

mkdir -p $DATA_DIR

echo "[step-4.1] finish!"


echo "[step-4.2] change source owner to postgres..."

chown -R postgres:postgres $SOURCE_DIR

echo "[step-4.2] finish!"


echo "[step-5] configure and compile as postgres..."

sudo -u postgres bash <<EOF

set -e

cd $SOURCE_DIR

echo "[step-5.1] configure..."

./configure \
--prefix=$INSTALL_DIR \
--enable-debug \
--enable-cassert \
--enable-coverage \
--without-icu

echo "[step-5.1] finish!"

echo "[step-5.2] compile..."

make -j\$(nproc)

echo "[step-5.2] finish!"

EOF

echo "[step-5] finish!"


echo "[step-6] install postgres..."

cd $SOURCE_DIR
make install

echo "[step-6] finish!"


echo "[step-7] initialize database..."

chown -R postgres:postgres $DATA_DIR

sudo -u postgres $INSTALL_DIR/bin/initdb -D $DATA_DIR

echo "[step-7] finish!"


echo "[step-8] start postgres..."

sudo -u postgres $INSTALL_DIR/bin/pg_ctl \
-D $DATA_DIR \
-o "-p $PORT" \
-l $DATA_DIR/logfile \
start

sleep 3

echo "[step-8] finish!"


echo "[step-9] configure database..."

sudo -u postgres $INSTALL_DIR/bin/psql -p $PORT <<SQL
ALTER USER postgres PASSWORD '123456';
CREATE DATABASE test;
SQL

echo "[step-9] finish!"


echo "[done] PostgreSQL $PG_VERSION build completed!"
