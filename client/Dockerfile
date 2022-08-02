FROM phusion/baseimage:master AS build

RUN  apt-get update \
    && apt-get install -y jq \
    && apt-get install -y curl

WORKDIR /wasmflow
RUN curl -L https://github.com/wasmflow/wasmflow/releases/latest/download/wasmflow.linux.aarch64.tar.gz --output wasmflow.linux.aarch64.tar.gz
RUN tar xf wasmflow.linux.aarch64.tar.gz
RUN cp ./wasmflow/wasmflow /usr/local/bin/wasmflow
RUN cp ./wasmflow/wafl /usr/local/bin/wafl
RUN chmod +x /usr/local/bin/wafl
RUN chmod +x /usr/local/bin/wasmflow
RUN rm -rf /wasmflow

WORKDIR /opt/wasmflow/app