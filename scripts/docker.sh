#!/bin/sh -eux

# See https://docs.docker.com/engine/install/ubuntu/
# And https://get.docker.com

export DEBIAN_FRONTEND=noninteractive

apt-get install -y apt-transport-https gnupg
wget -qO- https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

apt-get -y update
apt-get install -y --no-install-recommends \
    docker-ce$DOCKER_PKG_VERSION \
    docker-ce-cli$DOCKER_PKG_VERSION \
    containerd.io

usermod -aG docker vagrant
