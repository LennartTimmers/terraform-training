# #LIONS

# resource "azurerm_resource_group" "lions" {
#   for_each = local.lions
#   name     = each.value
#   location = "West Europe"
#   tags = merge(
#     {
#       fence = data.azurerm_resource_group.fence.id
#     },
#     {
#       for key, rg in data.azurerm_resource_group.crocodiles :
#       "crocodilebuddy_${key}" => rg.name
#     }
#   )
# }
# data "azurerm_resource_group" "fence" {
#   name = "fence"
# }

# data "azurerm_resource_group" "crocodiles" {
#   for_each = local.crocodiles
#   name = each.value
# }


# #CROCODILES
# resource "azurerm_resource_group" "crocodiles" {  
#   for_each = local.crocodiles 
#   name     = each.value
#   location = "West Europe"
#   tags = {fence = data.azurerm_resource_group.fence.name, tag2 = "value2"}
# }

# data "azurerm_resource_group" "fence" {
#   name = "fence"
# }

# #FENCE
# resource "azurerm_resource_group" "fence" {
#   name     = "Fence"
#   location = "West Europe"
#   tags = {tag1 = "value1", tag2 = "value2"}
# }
