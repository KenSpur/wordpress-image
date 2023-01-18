# Azure Credentials
variable "client_id" {
  type      = string
  sensitive = true
}
variable "client_secret" {
  type      = string
  sensitive = true
}

# Azure Subscription
variable "tenant_id" {
  type = string
}
variable "subscription_id" {
  type = string
}

# Azure Resource Group
variable "resource_group" {
  type = string
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
  sensitive = true
}
variable "mysql_host" {
  type = string
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