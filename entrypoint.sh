#!/usr/bin/env bash
set -euEo pipefail
trap 'RC=$?; echo [error] exit code $RC running $BASH_COMMAND; exit $RC' ERR

exec gosu app "$@"
