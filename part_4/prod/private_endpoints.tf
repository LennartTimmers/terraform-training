resource "azurerm_private_endpoint" "docs" {
  name                = "docs-endpoint"
  resource_group_name = azurerm_resource_group.docs_website.name
  location            = var.location
  subnet_id           = var.network_configuration.docs_storage_subnet_id

  private_service_connection {
    name                           = "docs-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.docs.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

resource "azurerm_private_endpoint" "website" {
  name                = "website-storage-endpoint"
  resource_group_name = azurerm_resource_group.website.name
  location            = var.location
  subnet_id           = var.network_configuration.website_subnet_id

  private_service_connection {
    name                           = "website-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.website.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}


resource "azurerm_private_endpoint" "vault" {
  name                = "vault-endpoint"
  resource_group_name = azurerm_resource_group.shared.name
  location            = var.location
  subnet_id           = var.network_configuration.shared_subnet_id

  private_service_connection {
    name                           = "keyvault-privateserviceconnection"
    private_connection_resource_id = azurerm_key_vault.shared.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}
