FROM python:3.6-alpine
MAINTAINER Alexandru Ast <alexandru.ast@gmail.com>

COPY [ "requirements.txt", "kvstore.py", "/" ]

RUN pip install -r /requirements.txt \
&& python kvstore.py --help

VOLUME [ "/config", "/import" ]

CMD ["python", "kvstore.py"]