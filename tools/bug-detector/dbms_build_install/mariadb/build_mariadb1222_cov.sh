#!/bin/bash
set -e

echo "[step-0] install dependencies..."
apt-get update && apt-get install -y \
    build-essential cmake libssl-dev libncurses5-dev libncursesw5-dev \
    bison libgnutls28-dev pkg-config libevent-dev liblz4-dev libzstd-dev \
    libcurl4-openssl-dev libicu-dev libpcre2-dev libfmt-dev git \
    lcov gcovr lsof

echo "[step-0] done!"

# ------------------------
# 变量配置
# ------------------------
export VERSION="mariadb-12.2.2"
export BASE_DIR="/app/dbms"
export SOURCE_DIR="$BASE_DIR/mariadb-12.2.2"
export BUILD_DIR="$SOURCE_DIR/build"
export INSTALL_DIR="/usr/local/mariadb1222"
export DATA_DIR="$SOURCE_DIR/data"
export SOCKET="/tmp/mariadb.sock"
export PORT=3307
export USER=root
export ROOT_PASS=123456

# ------------------------
# clone source
# ------------------------
cd $BASE_DIR
if [ ! -d "$SOURCE_DIR" ]; then
    git clone --branch $VERSION --depth 1 https://github.com/MariaDB/server mariadb-12.2.2
fi

# ------------------------
# configure + coverage
# ------------------------
cd $SOURCE_DIR
rm -rf build
mkdir -p build
cd build

export CFLAGS="--coverage -O0 -g -fno-inline -fno-inline-functions"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="--coverage"

#cmake .. \
#  -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
#  -DCMAKE_BUILD_TYPE=Debug \
#  -DWITH_DEBUG=ON \
#  -DCMAKE_C_FLAGS="$CFLAGS" \
#  -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
#  -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
#  -DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS" \
#  -DWITH_UNIT_TESTS=OFF \
#  -DWITH_LIBFMT=bundled \
#  -DPLUGIN_TOKUDB=NO \
#  -DPLUGIN_ROCKSDB=NO \
#  -DWITH_SSL=system \
#  -DWITH_ZLIB=system

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DWITH_DEBUG=OFF \
  -DCMAKE_C_FLAGS="$CFLAGS" \
  -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
  -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
  -DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS" \
  -DWITH_UNIT_TESTS=OFF \
  -DWITH_LIBFMT=bundled \
  -DPLUGIN_TOKUDB=NO \
  -DPLUGIN_ROCKSDB=NO \
  -DWITH_SSL=system \
  -DWITH_ZLIB=system

# ------------------------
# build + install
# ------------------------
make -j$(nproc)
make install

# ------------------------
# initialize DB
# ------------------------
mkdir -p "$DATA_DIR"
$INSTALL_DIR/scripts/mariadb-install-db \
    --basedir=$INSTALL_DIR \
    --datadir=$DATA_DIR \
    --auth-root-authentication-method=normal \
    --user=root

# ------------------------
# start server
# ------------------------
nohup $INSTALL_DIR/bin/mariadbd \
  --basedir=$INSTALL_DIR \
  --datadir=$DATA_DIR \
  --socket=$SOCKET \
  --port=$PORT \
  --bind-address=127.0.0.1 \
  --pid-file=$DATA_DIR/mariadb.pid \
  --user=$USER \
  --log-error=$DATA_DIR/error.log \
  > $DATA_DIR/stdout.log 2>&1 &

sleep 20

if ! $INSTALL_DIR/bin/mariadb-admin --socket=$SOCKET ping > /dev/null 2>&1; then
    echo "[ERROR] MariaDB failed to start"
    cat $DATA_DIR/error.log
    exit 1
fi

# ------------------------
# configure root + test DB
# ------------------------
$INSTALL_DIR/bin/mariadb -u root -h 127.0.0.1 -P $PORT <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASS';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '$ROOT_PASS';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
CREATE DATABASE IF NOT EXISTS test CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
FLUSH PRIVILEGES;
EOF

# ------------------------
# trigger coverage flush
# ------------------------
$INSTALL_DIR/bin/mariadb -u root -p$ROOT_PASS -h 127.0.0.1 -P $PORT <<EOF
USE test;
CREATE TABLE t0(c0 INT, c1 CHAR);
INSERT INTO t0 VALUES(1,'a');
SELECT * FROM t0;
DROP TABLE t0;
EOF

# ------------------------
# stop server to flush .gcda
# ------------------------
$INSTALL_DIR/bin/mariadb-admin --socket=$SOCKET shutdown
sleep 2

echo "[done] MariaDB ($VERSION) build + coverage-ready complete!"
echo "connect using: $INSTALL_DIR/bin/mariadb -u root -p$ROOT_PASS -h 127.0.0.1 -P $PORT"