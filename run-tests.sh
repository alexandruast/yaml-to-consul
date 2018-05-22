#!/usr/bin/env bash

SCRIPT="$(cat <<EOF
set -ex \
&& cd /project \
&& apk add -q --no-cache curl unzip \
&& curl -LSs https://releases.hashicorp.com/consul/1.0.6/consul_1.0.6_linux_amd64.zip -o /tmp/consul_1.0.6_linux_amd64.zip \
&& unzip /tmp/consul_1.0.6_linux_amd64.zip -d /tmp \
&& /tmp/consul agent -dev >/dev/null & \
&& pip install -r requirements.txt \
&& python tests/test_kvstore.py \
&& python kvstore.py
EOF
)"

docker run --rm -v "$(pwd):/project" python:3.6-alpine sc -c "${SCRIPT}"