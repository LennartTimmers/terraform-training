resource "random_string" "docs_db_user" {
  length  = 16
  special = false
}


resource "random_password" "docs_db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_string" "web_db_user" {
  length  = 16
  special = false
}


resource "random_password" "web_db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "web_db_password" {
  key_vault_id = azurerm_key_vault.shared.tenant_id
  name         = "WEB"
  value        = random_password.web_db_password.result
}

resource "azurerm_key_vault_secret" "docs_db_password" {
  key_vault_id = azurerm_key_vault.shared.tenant_id
  name         = "DOCS"
  value        = random_password.docs_db_password.result

}

resource "azurerm_postgresql_server" "docs" {
  name                = "${var.environment}-${local.docs_website_app_name}-db"
  location            = var.location
  resource_group_name = azurerm_resource_group.docs_website.name

  administrator_login          = random_string.docs_db_user.result
  administrator_login_password = random_password.docs_db_password.result

  sku_name   = "GP_Gen5_4"
  version    = "11"
  storage_mb = var.postgres_db_size

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_database" "docs" {
  name                = "docdb"
  resource_group_name = azurerm_resource_group.docs_website.name
  server_name         = azurerm_postgresql_server.docs.name
  charset             = "UTF8"
  collation           = "English_United States.1252"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_mssql_server" "website" {
  name                         = "${var.environment}-website-sql-server"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_mssql_database" "umbraco_cms" {
  name         = "umbraco-db"
  server_id    = azurerm_mssql_server.website.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"

  tags = {
    foo = "bar"
  }

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}
