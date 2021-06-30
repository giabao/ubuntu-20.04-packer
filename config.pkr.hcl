packer {
  required_version = ">= 1.6.2"
}

variable "cpus" {
  default = 1
}

variable "disk_size" {
  default = 8448
}

// Example: packer build -var "docker_pkg_version==5:20.10.7~3-0~ubuntu-focal" .
// empty string => install latest docker-ce and docker-ce-cli
variable "docker_pkg_version" {
  default = ""
}

// if set, we will: apt-get install -y linux-generic-$HWE_PKG
// valid values are: ["", "hwe-20.04", "hwe-20.04-edge"]
// see https://wiki.ubuntu.com/Kernel/LTSEnablementStack
variable "hwe_pkg" {
  default = ""
  validation {
    condition = contains(["", "hwe-20.04", "hwe-20.04-edge"], var.hwe_pkg)
    error_message = "Invalid hwe_pkg variable."
  }
}

variable "memory" {
  default = 512
}

variable "output_directory" {
  default = "build"
}

variable "vm_name" {
  default = "packer-ubuntu-20.04-server-amd64"
}

source "virtualbox-iso" "ubuntu" {
  boot_command             = [
    "<esc><wait>",
    "<esc><wait>",
    "<enter><wait>",
    "/install/vmlinuz<wait>",
    " auto<wait>",
    " console-setup/ask_detect=false<wait>",
    " console-setup/layoutcode=us<wait>",
    " console-setup/modelcode=pc105<wait>",
    " debconf/frontend=noninteractive<wait>",
    " debian-installer=en_US.UTF-8<wait>",
    " fb=false<wait>",
    " initrd=/install/initrd.gz<wait>",
    " kbd-chooser/method=us<wait>",
    " keyboard-configuration/layout=USA<wait>",
    " keyboard-configuration/variant=USA<wait>",
    " locale=en_US.UTF-8<wait>",
    " netcfg/get_domain=vm<wait>",
    " netcfg/get_hostname=vagrant<wait>",
    " grub-installer/bootdev=/dev/sda<wait>",
    " noapic<wait>",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
    " -- <wait>",
    "<enter><wait>"
  ]
  boot_wait                = "10s"
  disk_size                = "${var.disk_size}"
  guest_additions_path     = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type            = "Ubuntu_64"
  hard_drive_discard       = "true"
  hard_drive_interface     = "sata"
  hard_drive_nonrotational = "true"
  headless                 = "false"
  http_directory           = "http"
  iso_checksum             = "sha256:f11bda2f2caed8f420802b59f382c25160b114ccc665dbac9c5046e7fceaced2"
  iso_url                  = "http://cdimage.ubuntu.com/ubuntu-legacy-server/releases/20.04.1/release/ubuntu-20.04.1-legacy-server-amd64.iso"
  output_directory         = "${var.output_directory}"
  shutdown_command         = "echo 'vagrant' | sudo -S shutdown -P now"
  sound                    = "none"
  ssh_password             = "vagrant"
  ssh_port                 = 22
  ssh_timeout              = "10000s"
  ssh_username             = "vagrant"
  vboxmanage               = [
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"],
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"],
    ["modifyvm", "{{ .Name }}", "--audio", "none"],
    ["modifyvm", "{{ .Name }}", "--usb", "off"]
  ]
  vboxmanage_post          = [["modifyhd", "--compact", "${path.cwd}/${var.output_directory}/${var.vm_name}.vdi"]]
  virtualbox_version_file  = ".vbox_version"
  vm_name                  = "${var.vm_name}"
}

build {
  description = "A Packer template to build Ubuntu 20.04 Server box"

  sources = ["source.virtualbox-iso.ubuntu"]

  provisioner "shell" {
    environment_vars  = [
      "HWE_PKG=${var.hwe_pkg}",
      "DOCKER_PKG_VERSION=${var.docker_pkg_version}",
      "HOME_DIR=/home/vagrant"
    ]
    execute_command   = "echo 'vagrant' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    expect_disconnect = true
    scripts           = [
      "scripts/update.sh",
      "scripts/docker.sh",
      "scripts/sshd.sh",
      "scripts/networking.sh",
      "scripts/sudoers.sh",
      "scripts/vagrant.sh",
      "scripts/virtualbox.sh",
      "scripts/cleanup.sh",
      "scripts/minimize.sh"
    ]
  }

  post-processor "vagrant" {
    compression_level = "9"
    output            = "ubuntu-server-${
      var.hwe_pkg == ""? "20.04" : var.hwe_pkg
      }${
      var.docker_pkg_version == "skip"? "" : "-docker"
      }.box"
  }
}
