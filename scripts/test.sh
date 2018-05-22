#!/usr/bin/env bash
set -euEo pipefail
trap 'RC=$?; echo [error] exit code $RC running $BASH_COMMAND; exit $RC' ERR
docker run -it --rm -v "./:/project" python:3.6-alpine /project/scripts/run_tests.sh