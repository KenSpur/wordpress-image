# Azure Variables
variable "resource_group" {
  type    = string
  default = ""
}

variable "gallery_name" {
  type    = string
  default = ""
}

variable "image_name" {
  type    = string
  default = "img-wordpress"
}

variable "image_version" {
  type    = string
  default = "1.0.0"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "replication_regions" {
  type    = list(string)
  default = ["West Europe"]
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
  type    = string
  default = ""
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