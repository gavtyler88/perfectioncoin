#!/bin/bash
#
# The PerfectionCoin developers
# file COPYING 
#
# Check for duplicate includes.

filter_suffix() {
    git ls-files | grep -E "^src/.*\.${1}"'$' | grep -Ev "/(leveldb|secp256k1|univalue)/"
}

EXIT_CODE=0
for HEADER_FILE in $(filter_suffix h); do
    DUPLICATE_INCLUDES_IN_HEADER_FILE=$(grep -E "^#include " < "${HEADER_FILE}" | sort | uniq -d)
    if [[ ${DUPLICATE_INCLUDES_IN_HEADER_FILE} != "" ]]; then
        echo "Duplicate include(s) in ${HEADER_FILE}:"
        echo "${DUPLICATE_INCLUDES_IN_HEADER_FILE}"
        echo
        EXIT_CODE=1
    fi
done
for CPP_FILE in $(filter_suffix cpp); do
    DUPLICATE_INCLUDES_IN_CPP_FILE=$(grep -E "^#include " < "${CPP_FILE}" | sort | uniq -d)
    if [[ ${DUPLICATE_INCLUDES_IN_CPP_FILE} != "" ]]; then
        echo "Duplicate include(s) in ${CPP_FILE}:"
        echo "${DUPLICATE_INCLUDES_IN_CPP_FILE}"
        echo
        EXIT_CODE=1
    fi
done
exit ${EXIT_CODE}
