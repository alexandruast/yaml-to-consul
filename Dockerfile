FROM python:3.6-alpine

RUN apk add -q --no-cache curl bash \
&& adduser -D -H -s /bin/false app app

ARG GOSU_VERSION=1.10

COPY [ \
"gosu-${GOSU_VERSION}.sha256", \
"/tmp/" ]

RUN curl -LSs https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 -o /usr/local/bin/gosu-amd64 \
&& cd /usr/local/bin \
&& grep "gosu-amd64"'$' /tmp/gosu-${GOSU_VERSION}.sha256 | sha256sum -c - \
&& mv gosu-amd64 gosu \
&& chmod +x /usr/local/bin/gosu

COPY app/* /app/

RUN rm -fr /app/config /app/import \
&& pip install -r /app/requirements.txt

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

VOLUME [ "/app/config", "/app/import" ]

WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]
CMD ["python", "kvstore.py"]