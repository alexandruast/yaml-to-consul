#!/usr/bin/env sh
set -ex
cd /project
apk add -q --no-cache curl unzip
curl -LSs https://releases.hashicorp.com/consul/1.0.6/consul_1.0.6_linux_amd64.zip -o /tmp/consul_1.0.6_linux_amd64.zip
unzip /tmp/consul_1.0.6_linux_amd64.zip -d /tmp
nohup /tmp/consul agent -dev
pip install -r requirements.txt
python tests/test_kvstore.py
python kvstore.py
