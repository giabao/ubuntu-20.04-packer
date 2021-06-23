# ubuntu-20.04-packer
[Packer](https://www.packer.io/) template to build Ubuntu 20.04 Server x64 Vagrant box with [docker installed](https://docs.docker.com/engine/install/ubuntu/).

Based on [chef/bento](https://github.com/chef/bento) project.

## Usage
Published to [sandinh/ubuntu-docker box](https://app.vagrantup.com/sandinh/boxes/ubuntu-docker) on app.vagrantup.com

## Build
```sh
$ packer build .
```
or
```sh
$ packer build \
    -var "docker_pkg_version==5:20.10.7~3-0~ubuntu-focal" \
    -var "hwe_pkg=hwe-20.04-edge" \
    .
```
