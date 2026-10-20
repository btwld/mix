FROM ubuntu:24.04

ARG FVM_VERSION=4.3.2

ENV DEBIAN_FRONTEND=noninteractive \
    FVM_CACHE_PATH=/opt/fvm \
    FVM_USE_GIT_CACHE=false \
    PUB_CACHE=/home/ubuntu/.pub-cache \
    PATH=/opt/fvm-cli/bin:/home/ubuntu/.pub-cache/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git unzip xz-utils zip tar bash sudo \
    && rm -rf /var/lib/apt/lists/* \
    && (id -u ubuntu >/dev/null 2>&1 || useradd -m -s /bin/bash ubuntu) \
    && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
    && git config --system --add safe.directory '*' \
    && mkdir -p /opt/fvm /opt/fvm-cli \
    && chown -R ubuntu:ubuntu /opt/fvm /opt/fvm-cli

USER ubuntu
WORKDIR /home/ubuntu

RUN curl -fsSL https://fvm.app/install.sh | FVM_INSTALL_DIR=/opt/fvm-cli bash -s "${FVM_VERSION}" \
    && fvm --version
