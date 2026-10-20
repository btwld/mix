FROM ubuntu:24.04

ARG FVM_VERSION=4.3.2

ENV DEBIAN_FRONTEND=noninteractive \
    CURSOR_CLOUD_ENV=true \
    FVM_CACHE_PATH=/home/ubuntu/fvm \
    FVM_USE_GIT_CACHE=false \
    PUB_CACHE=/home/ubuntu/.pub-cache \
    PATH=/home/ubuntu/fvm/bin:/home/ubuntu/fvm/default/bin:/home/ubuntu/.pub-cache/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git unzip xz-utils zip tar bash sudo \
    && rm -rf /var/lib/apt/lists/* \
    && (id -u ubuntu >/dev/null 2>&1 || useradd -m -s /bin/bash ubuntu) \
    && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
    && git config --system --add safe.directory '*'

USER ubuntu
WORKDIR /home/ubuntu

RUN curl -fsSL https://fvm.app/install.sh | bash -s "${FVM_VERSION}" \
    && sudo ln -sf /home/ubuntu/fvm/bin/fvm /usr/local/bin/fvm \
    && fvm config --no-use-git-cache --no-update-check \
    && fvm --version
