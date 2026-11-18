resource "azurerm_resource_group" "fence" {
  name     = "fence"
  location = "West Europe"
  tags     = {val1: "var1"}
}