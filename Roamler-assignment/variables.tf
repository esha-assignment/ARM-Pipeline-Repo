
variable "location" {
  description = "The Azure region to deploy resources in"
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "keyvault" {
  description = "name of the keyvault"
  type        = string
}

variable "app_service_plan" {
  description = "name of the AppServicePlan"
  type        = string
}

variable "managedidentity" {
  description = "name of the identity"
  type        = string
}

variable "functionapp" {
  description = "name of the functionapp"
  type        = string
}


