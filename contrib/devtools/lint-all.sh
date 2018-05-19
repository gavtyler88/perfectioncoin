#!/bin/bash
#
# The PerfectionCoin developers
# file COPYING
#
# This script runs all contrib/devtools/lint-*.sh files, and fails if any exit
# with a non-zero status code.

set -u

SCRIPTDIR=$(dirname "${BASH_SOURCE[0]}")
LINTALL=$(basename "${BASH_SOURCE[0]}")

for f in "${SCRIPTDIR}"/lint-*.sh; do
  if [ "$(basename "$f")" != "$LINTALL" ]; then
    if ! "$f"; then
      echo "^---- failure generated from $f"
      exit 1
    fi
  fi
done
