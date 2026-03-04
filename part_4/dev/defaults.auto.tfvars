environment = "dev"
docs_storage_containers = [{
  access_type = "private"
  name        = "secrets"
  }, {
  access_type = "blob"
  name        = "website"
}]

postgres_db_size = 32000
network_configuration = {
  docs_storage_subnet_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-docstorage-subnet"
  docs_subnet_id         = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-doc-subnet"
  shared_subnet_id       = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-shared-subnet"
  website_subnet_id      = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-website-subnet"
}
