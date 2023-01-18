source "azure-arm" "wordpress-mysql-image" {
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

build {
  sources = [
    "source.azure-arm.wordpress-mysql-image"
  ]

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
    source      = "playbooks/files/apache.conf.j2"
    destination = "/tmp/apache.conf.j2"
  }

  provisioner "file" {
    source      = "playbooks/files/wp-config.php.j2"
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

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
  }
}