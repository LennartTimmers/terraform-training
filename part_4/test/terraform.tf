terraform {
  required_version = ">= 1.10"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.62.1"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "3.90.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }
}
