variable "account_replication_type" {
  description = "Replication Type"
  type        = string
  default     = "LRS"
}

variable "account_tier" {
  description = "Tier"
  type        = string
  default     = "Standard"
}

variable "name" {
  description = "Name of storage account"
  type        = string
  default     = "myfirststorageprac"
}

variable "resource_group_name" {
  description = "name of rg"
  type = string
  default = "myrg"
}

variable "location" {
  description = "value"
  type        = string
  default     = "West US"
}
variable "vnetid" {
  description = "vnet id"
  type        = string
}

variable "pesubnetid" {
  description = "id of subnet associated with private endpoint of storage account"
  type        = string
}
