#!/usr/bin/env bash
set -euo pipefail

PROGRESS="${1:-./progress}"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

pass=0
fail=0

run_test() {
    local name="$1"
    local input="$2"
    local out="$TMP/out"
    local size
    size=$(wc -c < "$input")

    if "$PROGRESS" < "$input" > "$out" 2>/dev/null && cmp -s "$input" "$out"; then
        printf "PASS  %s (%d B)\n" "$name" "$size"
        pass=$((pass + 1))
    else
        printf "FAIL  %s (%d B)\n" "$name" "$size"
        fail=$((fail + 1))
    fi
}

# Empty file
touch "$TMP/empty"
run_test "empty file" "$TMP/empty"

# Tiny text
printf 'hello world\n' > "$TMP/tiny.txt"
run_test "tiny text" "$TMP/tiny.txt"

# Small text — under one 4096-byte read chunk
seq 1 100 > "$TMP/small.txt"
run_test "small text" "$TMP/small.txt"

# Exact chunk boundary
dd if=/dev/urandom bs=4096 count=1 > "$TMP/chunk.bin" 2>/dev/null
run_test "exact chunk boundary" "$TMP/chunk.bin"

# One byte over a chunk boundary
dd if=/dev/urandom bs=4096 count=1 > "$TMP/over.bin" 2>/dev/null
printf 'x' >> "$TMP/over.bin"
run_test "chunk + 1 byte" "$TMP/over.bin"

# Medium text — several chunks
seq 1 10000 > "$TMP/medium.txt"
run_test "medium text" "$TMP/medium.txt"

# Binary with null bytes (all zeros)
dd if=/dev/zero bs=4096 count=4 > "$TMP/zeros.bin" 2>/dev/null
run_test "binary null bytes" "$TMP/zeros.bin"

# Binary with all 256 byte values
python3 -c "import sys; sys.stdout.buffer.write(bytes(range(256)) * 16)" > "$TMP/allbytes.bin"
run_test "all byte values" "$TMP/allbytes.bin"

# Large random binary (~10 MB)
dd if=/dev/urandom bs=1M count=10 > "$TMP/large.bin" 2>/dev/null
run_test "large binary" "$TMP/large.bin"

# Large text (~5 MB)
seq 1 500000 > "$TMP/large.txt"
run_test "large text" "$TMP/large.txt"

printf "\n%d passed, %d failed\n" "$pass" "$fail"
[ "$fail" -eq 0 ]
