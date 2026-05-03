#!/bin/bash
set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 OUTPUT_DIR"
    exit 1
fi

OUTPUT_DIR=$1
SOURCE_DIR="/app/dbms/mysql-8.4.8"
BUILD_DIR="$SOURCE_DIR/build"

RAW_INFO="$OUTPUT_DIR/raw.info"
DETAIL_INFO="$OUTPUT_DIR/detail.info"
SUMMARY_FILE="$OUTPUT_DIR/summary.txt"

echo "[step-0] prepare directories..."

mkdir -p "$OUTPUT_DIR"

echo "[step-0] finish!"

echo "[step-1] capture coverage data..."

lcov \
  --capture \
  --directory "$BUILD_DIR" \
  --output-file "$RAW_INFO" \
  --rc lcov_branch_coverage=1

echo "[step-1] finish!"

echo "[step-2] keep only core MySQL source (sql + storage + include)..."

lcov \
  --extract "$RAW_INFO" \
  "$SOURCE_DIR/sql/*" \
  "$SOURCE_DIR/storage/*" \
  --output-file "$DETAIL_INFO" \
  --rc lcov_branch_coverage=1

echo "[step-2] finish!"

echo "[step-3] generate html report..."

genhtml \
  "$DETAIL_INFO" \
  --output-directory "$OUTPUT_DIR/html" \
  --branch-coverage \
  --function-coverage

echo "[step-3] finish!"

echo "[step-4] move index.html..."

cp "$OUTPUT_DIR/html/index.html" "$OUTPUT_DIR/index.html"

echo "[step-4] finish!"

echo "[step-5] generate summary..."

lcov --summary "$DETAIL_INFO" --rc lcov_branch_coverage=1 > "$SUMMARY_FILE"

echo "[step-5] finish!"

echo "[step-6] cleanup temporary files..."

rm -rf "$OUTPUT_DIR/html"
rm -f "$RAW_INFO"

echo "[step-6] finish!"

echo "[done] coverage report generated in $OUTPUT_DIR"
