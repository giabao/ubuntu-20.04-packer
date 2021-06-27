# ubuntu-20.04-packer
[Packer](https://www.packer.io/) template to build Ubuntu 20.04 Server x64 Vagrant box with [docker installed](https://docs.docker.com/engine/install/ubuntu/).

Based on [chef/bento](https://github.com/chef/bento) project.

Some packages are purged such as X11, development, docs,..

## Variants
+ 20.04.*.hwe: Install kernel in linux-generic-hwe-20.04
+ 20.04.*.hwe: Install kernel in linux-generic-hwe-20.04-edge
+ 20.04.*: Default kernel
See [LTS Enablement Stacks](https://wiki.ubuntu.com/Kernel/LTSEnablementStack)

## Usage
Published to [sandinh/ubuntu-docker box](https://app.vagrantup.com/sandinh/boxes/ubuntu-docker) on app.vagrantup.com

## Build
example:
```sh
$ packer build -var "docker_pkg_version=skip" .
```

####vars:
##### docker_pkg_version
+ `""` (default) | `"latest"` => install latest docker
+ `"skip"` => skip installing docker
+ a version as output in `apt-cache madison docker-ce` => install a specific docker version. Ex:
`packer build -var "docker_pkg_version=5:20.10.7~3-0~ubuntu-focal" .`
##### hwe_pkg
+ `""` (default) => skip installing hwe
+ `hwe-20.04` => install `linux-generic-hwe-20.04`
+ `hwe-20.04-edge` => install `linux-generic-hwe-20.04-edge`
