
data "azurerm_client_config" "current" {}

# Resource Group #
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# # Storage Account #
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Key Vault
resource "azurerm_key_vault" "keyvault" {
  name                        = var.keyvault
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  }


# Application Service Plan
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "P1v2"
  os_type             = "Windows"
  
}

# # Function App Identity
resource "azurerm_user_assigned_identity" "function_identity" {
  name                = var.managedidentity
  resource_group_name = var.resource_group_name
  location            = var.location
}

# # Key Vault Access Policy to allow Function App to read secrets

resource "azurerm_key_vault_access_policy" "kv_policy" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.function_identity.principal_id

  secret_permissions = [
    "Get",
    "List",
  ]
}

# # Function App
resource "azurerm_windows_function_app" "functionapp" {
  name                       = var.functionapp
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = azurerm_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  site_config {}
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.function_identity.id]
  }

  depends_on = [
    azurerm_key_vault_access_policy.kv_policy
    
  ]
}



