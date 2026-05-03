#!/bin/bash

set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 OUTPUT_DIR"
    exit 1
fi

OUTPUT_DIR=$1

SOURCE_DIR="/app/dbms/postgresql-18.3"

RAW_INFO="$OUTPUT_DIR/raw.info"
DETAIL_INFO="$RAW_INFO"
SUMMARY_FILE="$OUTPUT_DIR/summary.txt"

echo "[step-0] prepare directories..."

mkdir -p "$OUTPUT_DIR"

echo "[step-0] finish!"


echo "[step-1] capture coverage data..."

lcov \
--capture \
--directory "$SOURCE_DIR" \
--output-file "$RAW_INFO" \
--rc lcov_branch_coverage=1

echo "[step-1] finish!"


echo "[step-2] generate html report..."

genhtml \
"$DETAIL_INFO" \
--output-directory "$OUTPUT_DIR/html" \
--branch-coverage \
--function-coverage

echo "[step-2] finish!"


echo "[step-3] move index.html..."

cp "$OUTPUT_DIR/html/index.html" "$OUTPUT_DIR/index.html"

echo "[step-3] finish!"


echo "[step-4] generate summary..."

lcov --summary "$DETAIL_INFO" --rc lcov_branch_coverage=1 > "$SUMMARY_FILE"

echo "[step-4] finish!"


echo "[step-5] cleanup temporary files..."

rm -rf "$OUTPUT_DIR/html"
rm -f "$RAW_INFO"

echo "[step-5] finish!"


echo "[done] coverage report generated in $OUTPUT_DIR"
