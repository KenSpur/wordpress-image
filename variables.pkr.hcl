# Azure Variables
variable "resource_group" {
  type    = string
}

variable "gallery_name" {
  type    = string
}

variable "image_name" {
  type    = string
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
}
variable "mysql_user" {
  type    = string
}
variable "mysql_password" {
  type      = string
  sensitive = true
}
variable "mysql_host" {
  type    = string
}