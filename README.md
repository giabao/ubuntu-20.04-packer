# ubuntu-20.04-packer
[Packer](https://www.packer.io/) template to build Ubuntu 20.04 Server x64 [Vagrant](https://www.vagrantup.com/) box. Based on [chef/bento](https://github.com/chef/bento) project.

This fork also install [linux-generic-hwe-20.04](https://wiki.ubuntu.com/Kernel/LTSEnablementStack) and [docker](https://docs.docker.com/engine/install/ubuntu/)

## Usage
```sh
$ packer build template.json
```
