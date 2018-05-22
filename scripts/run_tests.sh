#!/usr/bin/env bash
set -euEo pipefail
trap 'RC=$?; echo [error] exit code $RC running $BASH_COMMAND; exit $RC' ERR
cd /project
wget https://releases.hashicorp.com/consul/1.0.6/consul_1.0.6_linux_amd64.zip
unzip consul_1.0.6_linux_amd64.zip
mv ./consul /usr/bin/consul
rm -f consul_1.0.6_linux_amd64.zip
consul agent -dev
pip install -r requirements.txt
python ./tests/test_kvstore.py
python ./kvstore.py
