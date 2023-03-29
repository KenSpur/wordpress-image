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
