# Azure Subscription
variable "tenant_id" {
  type = string
  default   = ""
}
variable "subscription_id" {
  type = string
  default   = ""
}

# Azure Resource Group
variable "resource_group" {
  type = string
  default   = ""
}
variable "image_name" {
  type    = string
  default = "img-wordpress"
}
variable "location" {
  type    = string
  default = "westeurope"
}

# Mysql Settings
variable "mysql_db" {
  type    = string
  default = "wordpressdb"
}
variable "mysql_user" {
  type    = string
  default = "wordpress"
}
variable "mysql_password" {
  type      = string
  default   = "wordpress"
  sensitive = true
}
variable "mysql_host" {
  type = string
  default   = ""
}

# Http Settings
variable "http_host" {
  type    = string
  default = "your_domain"
}
variable "http_conf" {
  type    = string
  default = "your_domain.conf"
}
variable "http_port" {
  type    = string
  default = "80"
}

# Proxmox Variables
variable "proxmox_api_url" {
  type    = string
  default = ""
}

variable "proxmox_api_token_id" {
  type    = string
  default = ""
}

variable "proxmox_api_token_secret" {
  type      = string
  default   = ""
  sensitive = true
}

variable "proxmox_node" {
  type    = string
  default = "pve"
}

variable "ssh_username" {
  type    = string
  default = "root"
}