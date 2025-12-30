#!/usr/bin/env bash
set -euo pipefail

cleanup() {
    rm -rf output
}
trap cleanup EXIT

GO_SQLITE3_URL="https://github.com/ncruces/go-sqlite3/archive/refs/tags/v0.30.3.tar.gz"
GO_SQLITE3_FILE="go-sqlite3-v0.30.3.tar.gz"
SQLITE_VEC_URL="https://github.com/asg017/sqlite-vec/releases/download/v0.1.7-alpha.2/sqlite-vec-0.1.7-alpha.2-amalgamation.tar.gz"
SQLITE_VEC_FILE="sqlite-vec-0.1.7-alpha.2-amalgamation.tar.gz"

CACHE_DIR="download-cache"

# Clean up output directory
rm -rf output
mkdir -p output/sqlite3
mkdir -p "$CACHE_DIR"

# Download go-sqlite3 if not cached
if [[ ! -f "$CACHE_DIR/$GO_SQLITE3_FILE" ]]; then
    echo "Downloading go-sqlite3..."
    curl -#L "$GO_SQLITE3_URL" -o "$CACHE_DIR/$GO_SQLITE3_FILE"
else
    echo "Using cached go-sqlite3"
fi
tar xzf "$CACHE_DIR/$GO_SQLITE3_FILE" -C output --strip-components=1

# Download sqlite-vec if not cached
if [[ ! -f "$CACHE_DIR/$SQLITE_VEC_FILE" ]]; then
    echo "Downloading sqlite-vec..."
    curl -#L "$SQLITE_VEC_URL" -o "$CACHE_DIR/$SQLITE_VEC_FILE"
else
    echo "Using cached sqlite-vec"
fi

# Patch build
cat *.patch | patch -p0 --no-backup-if-mismatch

./output/sqlite3/tools.sh
./output/sqlite3/download.sh

# Extract sqlite-vec AFTER download.sh (which runs `rm -r sqlite-*`)
tar xzf "$CACHE_DIR/$SQLITE_VEC_FILE" -C output/sqlite3

./output/embed/build.sh

# Copy output Wasm
mv output/embed/sqlite3.wasm sqlite-vec.wasm

# compress the wasm file
gzip -9 sqlite-vec.wasm