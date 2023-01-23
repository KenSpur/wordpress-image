source "azure-arm" "ubuntu-server-22_04-lts" {
  azure_tags = {
    build_by = "packer"
  }

  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"

  location = "${var.location}"

  managed_image_resource_group_name = "${var.resource_group}"
  managed_image_name                = "${var.image_name}"

  vm_size         = "Standard_B1s"
  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts-gen2"
  image_version   = "latest"
}

source "proxmox-clone" "ubuntu-server-22-04-lts" {
  proxmox_url              = "${var.proxmox_api_url}"
  username                 = "${var.proxmox_api_token_id}"
  token                    = "${var.proxmox_api_token_secret}"
  insecure_skip_tls_verify = true

  node     = "${var.proxmox_node}"
  clone_vm = "ubuntu-server-22-04-lts"

  vm_name              = "wordpress"
  template_description = "Wordpress"

  cores  = "1"
  memory = "2048"

  ssh_username = "${var.ssh_username}"
}

build {
  sources = [
    "source.azure-arm.ubuntu-server-22_04-lts",
    "source.proxmox-clone.ubuntu-server-22-04-lts"
  ]

  provisioner "shell" {
    inline = [
      "while ! cloud-init status | grep -q 'done'; do echo 'Waiting for cloud-init...'; sleep 5s; done"
    ]
    only = ["proxmox-clone.ubuntu-server-22-04-lts"]
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline = [
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get install ansible -y"
    ]
    inline_shebang = "/bin/sh -x"
  }

  provisioner "file" {
    source      = "files/apache.conf.j2"
    destination = "/tmp/apache.conf.j2"
  }

  provisioner "file" {
    source      = "files/wp-config.php.j2"
    destination = "/tmp/wp-config.php.j2"
  }

  provisioner "ansible-local" {
    playbook_file = "./playbooks/provision-wordpress.yml"
    extra_arguments = [
      "-e", "mysql_db=${var.mysql_db}",
      "-e", "mysql_user=${var.mysql_user}",
      "-e", "mysql_password=${var.mysql_password}",
      "-e", "mysql_host=${var.mysql_host}",
      "-e", "http_host=${var.http_host}",
      "-e", "http_conf=${var.http_conf}",
      "-e", "http_port=${var.http_port}"
    ]
  }

  # cleanups
  provisioner "shell" {
    inline = [
      "sudo apt-get purge ansible -y"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt-get autoremove --purge -y",
      "sudo apt-get clean -y ",
      "sudo apt-get autoclean -y",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo sync"
    ]
    only = ["proxmox-clone.ubuntu-server-22-04-lts"]
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
    only = ["azure-arm.ubuntu-server-22_04-lts"]
  }
}