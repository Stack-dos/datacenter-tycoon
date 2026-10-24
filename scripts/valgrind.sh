#!/usr/bin/env bash
# Corre todos los tests bajo Valgrind (build sin sanitizers: no se combinan con ASan).
set -euo pipefail
cd "$(dirname "$0")/.."
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DDCT_BUILD_TESTS=ON -DDCT_SANITIZE=OFF
cmake --build build
for t in build/tests/test_*; do
    echo "== valgrind $t"
    valgrind --leak-check=full --error-exitcode=1 "$t"
done
