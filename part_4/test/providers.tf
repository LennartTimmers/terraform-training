provider "random" {

}

provider "azurerm" {
  subscription_id = "12345678-1234-1234-1234-123456789012"

  features {
    key_vault {
      recover_soft_deleted_certificates                  = true
      recover_soft_deleted_hardware_security_module_keys = true
      recover_soft_deleted_key_vaults                    = true
      recover_soft_deleted_keys                          = true
      recover_soft_deleted_secrets                       = true
    }
  }
}

provider "datadog" {
  api_key = "dummy"
  app_key = "dummy"

  validate = "false"
}
