locals {
  website_app_name      = "website"
  docs_website_app_name = "docs-website"
}


data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "shared" {
  location = var.location
  name     = "shared-rg"
}


resource "azurerm_resource_group" "website" {
  location = var.location
  name     = "${var.environment}${local.website_app_name}-rg"
}


resource "azurerm_resource_group" "docs_website" {
  location = var.location
  name     = "${var.environment}${local.docs_website_app_name}-rg"
}

resource "azurerm_user_assigned_identity" "website_user" {
  location            = var.location
  name                = "${var.environment}${local.website_app_name}-mid"
  resource_group_name = azurerm_resource_group.website.name
}

resource "azurerm_user_assigned_identity" "doc_user" {
  location            = var.location
  name                = "${var.environment}${local.website_app_name}-mid"
  resource_group_name = azurerm_resource_group.docs_website.name
}


resource "azurerm_key_vault" "shared" {
  name                        = "shared"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.shared
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  rbac_authorization_enabled  = true
  sku_name                    = "standard"
}
