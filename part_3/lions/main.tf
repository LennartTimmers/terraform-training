resource "azurerm_resource_group" "lions" {
  for_each = local.lions
  name     = each.value
  location = "West Europe"
  tags = merge(
    {
      fence = data.azurerm_resource_group.fence.id
    },
    {
      for key, rg in data.azurerm_resource_group.crocodiles :
      "crocodilebuddy_${key}" => rg.name
    }
  )

  depends_on = [ data.azurerm_resource_group.fence ]
}

data "azurerm_resource_group" "fence" {
  name = "fence"
}

data "azurerm_resource_group" "crocodiles" {
  for_each = local.crocodiles
  name = each.value
}