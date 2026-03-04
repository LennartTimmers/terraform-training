resource "azurerm_cdn_profile" "website" {
  name                = "${local.docs_website_app_name}-cdn"
  location            = var.location
  resource_group_name = azurerm_resource_group.website.name
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "website" {
  name                = "website"
  profile_name        = azurerm_cdn_profile.website.name
  location            = var.location
  resource_group_name = azurerm_resource_group.website.name

  origin {
    name      = local.docs_website_app_name
    host_name = "www.${var.environment}.${local.website_app_name}.com"
  }
}

resource "datadog_synthetics_test" "test_uptime" {
  count = var.monitor_enabled == false ? 0 : 1

  name      = "An Uptime test on ${local.website_app_name} - ${var.environment}"
  type      = "api"
  subtype   = "http"
  status    = "live"
  message   = "Notify @hpichat"
  locations = ["aws:eu-central-1"]
  tags      = ["foo:bar", "foo", "env:test"]

  request_definition {
    method = "GET"
    url    = azurerm_cdn_endpoint.website.fqdn
  }

  request_headers = {
    Content-Type = "application/json"
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  options_list {
    tick_every = 900
    retry {
      count    = 2
      interval = 300
    }
    monitor_options {
      renotify_interval = 120
    }
  }
}
