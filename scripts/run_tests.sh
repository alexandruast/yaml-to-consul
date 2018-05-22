#!/usr/bin/env sh
set -ex
cd /project
apk add -q --no-cache curl bash
curl -LSs https://releases.hashicorp.com/consul/1.0.6/consul_1.0.6_linux_amd64.zip
unzip consul_1.0.6_linux_amd64.zip
mv ./consul /usr/bin/consul
rm -f consul_1.0.6_linux_amd64.zip
consul agent -dev
pip install -r requirements.txt
python ./tests/test_kvstore.py
python ./kvstore.py
