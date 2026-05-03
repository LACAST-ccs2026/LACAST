#!/bin/bash
set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 OUTPUT_DIR"
    exit 1
fi

# ------------------------
# 输出目录
# ------------------------
OUTPUT_DIR=$1
mkdir -p "$OUTPUT_DIR"

# ------------------------
# 源码和 build 目录
# ------------------------
SOURCE_DIR="/app/dbms/mariadb-12.2.2"
BUILD_DIR="$SOURCE_DIR/build"
INSTALL_DIR="/usr/local/mariadb1222"
DATA_DIR="$SOURCE_DIR/data"
SOCKET="/tmp/mariadb.sock"
PORT=3307
USER=root
ROOT_PASS="123456"

RAW_INFO="$OUTPUT_DIR/raw.info"
SUMMARY_FILE="$OUTPUT_DIR/summary.txt"
HTML_DIR="$OUTPUT_DIR/html"

# ------------------------
# step-0 正常停止 MariaDB 以触发 gcda 写入
# ------------------------
#echo "[step-0] gracefully stopping MariaDB to flush coverage data..."
#
## 使用正常方式停止（发送 SIGTERM，让 MariaDB 有机会调用 exit）
#if [ -S "$SOCKET" ]; then
#    $INSTALL_DIR/bin/mariadb-admin \
#        -u $USER \
#        -p$ROOT_PASS \
#        --socket=$SOCKET \
#        shutdown || true
#fi
#
## 等待进程完全退出（最多 30 秒）
#for i in {1..30}; do
#    if ! pgrep -x "mariadbd" > /dev/null 2>&1; then
#        echo "MariaDB stopped gracefully"
#        break
#    fi
#    sleep 1
#done
#
## 如果还有残留，再强制杀死（但会丢失这部分覆盖率数据）
#if pgrep -x "mariadbd" > /dev/null 2>&1; then
#    echo "Warning: MariaDB did not stop gracefully, forcing kill (coverage data may be lost)"
#    pkill -9 mariadbd || true
#    sleep 2
#fi
#
#echo "[step-0] done!"

# ------------------------
# step-1 检查并收集 coverage 数据
# ------------------------
echo "[step-1] checking for .gcda files..."

# 检查是否有 gcda 文件
GCDA_COUNT=$(find "$BUILD_DIR" -name "*.gcda" 2>/dev/null | wc -l)
echo "Found $GCDA_COUNT .gcda files"

if [ "$GCDA_COUNT" -eq 0 ]; then
    echo "[WARNING] No .gcda files found! Possible reasons:"
    echo "  1. MariaDB was killed too abruptly (use shutdown command)"
    echo "  2. Build was not compiled with --coverage flags"
    echo "  3. GCOV_PREFIX environment variable redirected files elsewhere"
    # 尝试查找可能的 gcda 位置
    find "$SOURCE_DIR" -name "*.gcda" 2>/dev/null | head -20 || true
fi

echo "[step-1] capture coverage data..."
lcov \
    --capture \
    --directory "$BUILD_DIR" \
    --output-file "$RAW_INFO" \
    --rc lcov_branch_coverage=1 \
    --ignore-errors source,gcov
echo "[step-1] done!"

# ------------------------
# step-2 生成 HTML 报告
# ------------------------
echo "[step-2] generate html report..."
genhtml "$RAW_INFO" \
    --output-directory "$HTML_DIR" \
    --branch-coverage \
    --function-coverage \
    --prefix "$SOURCE_DIR" \
    --ignore-errors source
echo "[step-2] done!"

# ------------------------
# step-3 拷贝 index.html 到 OUTPUT_DIR
# ------------------------
echo "[step-3] move index.html..."
cp "$HTML_DIR/index.html" "$OUTPUT_DIR/index.html"
echo "[step-3] done!"

# ------------------------
# step-4 生成 summary
# ------------------------
echo "[step-4] generate summary..."
lcov --summary "$RAW_INFO" --rc lcov_branch_coverage=1 > "$SUMMARY_FILE" 2>&1 || true
echo "[step-4] done!"

echo "[done] FULL coverage report generated in $OUTPUT_DIR"
echo "HTML report: $HTML_DIR/index.html"
echo "Summary: $SUMMARY_FILE"