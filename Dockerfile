FROM node:4-alpine

ENV PYTHONUNBUFFERED 1

RUN mkdir /code

WORKDIR /code

RUN apk add --no-cache \
        python-dev \
        py-pip \
        postgresql-dev \
        gcc \
        musl-dev \
        libffi-dev \
        openldap-dev \
        bash

RUN npm install -g \
        --registry http://registry.npmjs.org/ \
        coffee-script \
        less@1.3

RUN pip install --upgrade pip

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY requirements-dev.txt ./
RUN pip install --no-cache-dir -r requirements-dev.txt

COPY requirements-plugins.txt ./
RUN pip install --no-cache-dir -r requirements-plugins.txt

ADD . /code/

RUN chgrp -R 0 /code
RUN chmod -R g+rw /code

USER 1001

ENTRYPOINT ["./docker-entrypoint.sh"]
