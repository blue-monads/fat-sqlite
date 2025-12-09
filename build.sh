#!/usr/bin/env bash
set -euo pipefail

GO_SQLITE3="https://github.com/ncruces/go-sqlite3/archive/refs/tags/v0.27.1.tar.gz"
SQLITE_VEC="https://github.com/asg017/sqlite-vec/releases/download/v0.1.6/sqlite-vec-0.1.6-amalgamation.tar.gz"

# Clean up output directory
rm -rf output
mkdir -p output/sqlite3

# Download asg017/sqlite-vec
curl -#L "$SQLITE_VEC" | tar xzC output/sqlite3

# Download ncruces/go-sqlite3 
curl -#L "$GO_SQLITE3" | tar xzC output --strip-components=1

# Patch build
cat *.patch | patch -p0 --no-backup-if-mismatch

./output/sqlite3/tools.sh
./output/sqlite3/download.sh
./output/embed/build.sh

# Copy output Wasm
mv output/embed/sqlite3.wasm sqlite-vec.wasm
# rm -rf output