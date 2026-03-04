resource "azurerm_app_service_plan" "shared" {
  name                = "shared"
  location            = var.location
  resource_group_name = azurerm_resource_group.shared.name

  sku {
    size = try(var.shared_app_service_plan_sku.size, "S3")
    tier = try(var.shared_app_service_plan_sku.tier, "Standard")
  }
}
