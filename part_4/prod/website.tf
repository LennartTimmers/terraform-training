resource "azurerm_app_service" "website" {
  name                = "${var.environment}${local.website_app_name}-app"
  location            = var.location
  resource_group_name = azurerm_resource_group.website.name
  app_service_plan_id = azurerm_app_service_plan.shared.id

  site_config {
    always_on                   = false
    ftps_state                  = "Disabled"
    health_check_path           = "/healthz"
    number_of_workers           = 3
    http2_enabled               = true
    scm_use_main_ip_restriction = true
    min_tls_version             = "1.2"
    vnet_route_all_enabled      = true
    dotnet_framework_version    = "v4.0"
  }
}

resource "azurerm_app_service" "docs" {
  name                = "${var.environment}${local.docs_website_app_name}-app"
  location            = var.location
  resource_group_name = azurerm_resource_group.docs_website.name
  app_service_plan_id = azurerm_app_service_plan.shared.id

  site_config {
    always_on                   = false
    ftps_state                  = "Disabled"
    health_check_path           = "/docs"
    number_of_workers           = 1
    http2_enabled               = false
    scm_use_main_ip_restriction = false
    min_tls_version             = "1.2"
    vnet_route_all_enabled      = false
    dotnet_framework_version    = "v4.0"
  }

  app_settings = {
    "database_password" = "@Microsoft.KeyVault(${azurerm_key_vault_secret.docs_db_password.versionless_id})"
  }
}


resource "azurerm_storage_account" "website" {
  name                     = "${var.environment}${local.website_app_name}stor001"
  resource_group_name      = azurerm_resource_group.docs_website.name
  location                 = var.location
  account_tier             = var.website_storage_account_tier
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_role_assignment" "website_blob_contributor" {
  principal_id         = azurerm_user_assigned_identity.website_user.principal_id
  scope                = azurerm_storage_account.website.id
  role_definition_name = "Storage Blob Data Contributor"
}

resource "azurerm_role_assignment" "website_storage_table_contributor" {
  principal_id         = azurerm_user_assigned_identity.website_user.principal_id
  scope                = azurerm_storage_account.website.id
  role_definition_name = "Storage Table Data Contributor"
}

resource "azurerm_role_assignment" "website_storage_account_contributor" {
  principal_id         = azurerm_user_assigned_identity.website_user.principal_id
  scope                = azurerm_storage_account.website.id
  role_definition_name = "Storage Account Contributor"
}

resource "azurerm_role_assignment" "keyvault_secret_user" {
  principal_id         = azurerm_user_assigned_identity.website_user.principal_id
  scope                = azurerm_key_vault_secret.docs_db_password.resource_id
  role_definition_name = "Key Vault Secrets User"
}
