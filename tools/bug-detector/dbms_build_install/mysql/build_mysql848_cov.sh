#!/bin/bash
set -e

echo "[step-1] install dependencies..."

mkdir -p /app/dbms/
cd /app/dbms/

apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libssl-dev \
    libncurses5-dev \
    libncursesw5-dev \
    bison \
    libgnutls28-dev \
    pkg-config \
    libevent-dev \
    libboost-dev \
    liblz4-dev \
    libzstd-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    wget \
    curl \
    git \
    lcov \
    gcovr

echo "[step-1] finish!"

echo "[step-2] set environment variables..."

export MYSQL_VERSION="8.4.8"
export SOURCE_DIR="/app/dbms/mysql-$MYSQL_VERSION"
export BUILD_DIR="$SOURCE_DIR/build"
export INSTALL_DIR="/usr/local/mysql848"
export DATA_DIR="$SOURCE_DIR/data"
export SOCKET_PATH="/tmp/mysql.sock"
export USER="root"
export PORT="3306"

echo "[step-2] finish!"

echo "[step-3] download mysql source..."

if [ ! -f mysql-$MYSQL_VERSION.tar.gz ]; then
    wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-$MYSQL_VERSION.tar.gz
fi

echo "[step-3] finish!"

echo "[step-4] extract source..."

if [ ! -d "$SOURCE_DIR" ]; then
    tar -xzf mysql-$MYSQL_VERSION.tar.gz
fi

echo "[step-4] finish!"

echo "[step-5] configure build..."

cd mysql-$MYSQL_VERSION

mkdir -p build
cd build

CFLAGS="-fprofile-arcs -ftest-coverage -fPIC -O0 -g"
CXXFLAGS="-fprofile-arcs -ftest-coverage -fPIC -O0 -g"
LDFLAGS="-fprofile-arcs -ftest-coverage -lgcov"

cmake $SOURCE_DIR \
  -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
  -DCMAKE_C_FLAGS="$CFLAGS" \
  -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
  -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
  -DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS" \
  -DWITH_UNIT_TESTS=OFF \
  -DWITH_DEBUG=OFF \
  -DENABLE_DOWNLOADS=1 \
  -DWITH_BOOST=$SOURCE_DIR/boost \
  -DFORCE_INSOURCE_BUILD=OFF

echo "[step-5] finish!"

echo "[step-6] build mysql..."

make -j$(nproc)

echo "[step-6] finish!"

echo "[step-7] install mysql..."

make install

echo "[step-7] finish!"

echo "[step-8] initialize database..."

cd $SOURCE_DIR
mkdir -p data

$INSTALL_DIR/bin/mysqld \
   --initialize-insecure \
   --basedir=$INSTALL_DIR \
   --datadir=$DATA_DIR

echo "[step-8] finish!"

echo "[step-9] start mysql server..."

$INSTALL_DIR/bin/mysqld \
  --basedir=$INSTALL_DIR \
  --datadir=$DATA_DIR \
  --socket=$SOCKET_PATH \
  --port=$PORT \
  --bind-address=0.0.0.0 \
  --pid-file=$DATA_DIR/mysqld.pid \
  --user=$USER \
  --log-error=$DATA_DIR/error.log \
  --daemonize

sleep 5

echo "[step-9] finish!"

echo "[step-10] configure root password and create test database..."

$INSTALL_DIR/bin/mysql \
  -u $USER \
  -h 127.0.0.1 \
  -P $PORT <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';

CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

CREATE DATABASE IF NOT EXISTS test
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

FLUSH PRIVILEGES;
EOF

echo "[step-10] finish!"

echo ""
echo "[done] mysql build completed"
echo ""
echo "connect using:"
echo "$INSTALL_DIR/bin/mysql -u root -p123456 -h 127.0.0.1 -P $PORT"
