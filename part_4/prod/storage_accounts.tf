resource "azurerm_storage_account" "docs" {
  name                     = "${var.environment}${local.docs_website_app_name}stor001"
  resource_group_name      = azurerm_resource_group.docs_website.name
  location                 = var.location
  account_tier             = var.docs_storage_account_tier
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_role_assignment" "docs_blob_contributor" {
  principal_id         = azurerm_user_assigned_identity.doc_user.principal_id
  scope                = azurerm_storage_account.docs.id
  role_definition_name = "Storage Blob Data Contributor"
}

resource "azurerm_role_assignment" "docs_storage_table_contributor" {
  principal_id         = azurerm_user_assigned_identity.doc_user.principal_id
  scope                = azurerm_storage_account.docs.id
  role_definition_name = "Storage Table Data Contributor"
}

resource "azurerm_role_assignment" "docs_storage_account_contributor" {
  principal_id         = azurerm_user_assigned_identity.doc_user.principal_id
  scope                = azurerm_storage_account.docs.id
  role_definition_name = "Storage Account Contributor"
}

resource "azurerm_storage_container" "docs" {
  for_each = local.docs_storage_account_map

  name                  = each.value.name
  storage_account_id    = azurerm_storage_account.docs.id
  container_access_type = each.value.access_type
}
