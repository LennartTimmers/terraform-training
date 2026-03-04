variable "environment" {
  type = string

  validation {
    condition     = length(var.environment) < 4
    error_message = "Env name can be max 3 chars"
  }
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "website_storage_account_tier" {
  type    = string
  default = "Standard"
}

variable "docs_storage_account_tier" {
  type    = string
  default = "Standard"
}

variable "docs_storage_containers" {
  type = set(object({
    name        = string
    access_type = string
  }))
  default = []
}

variable "shared_app_service_plan_sku" {
  type = object({
    tier = optional(string, "Standard")
    size = optional(string, "S1")
  })

  default = {}
}

variable "monitor_enabled" {
  type = bool
}

variable "postgres_db_size" {
  type    = number
  default = 64000
}


variable "network_configuration" {
  type = object({
    shared_subnet_id       = string
    website_subnet_id      = string
    docs_subnet_id         = string
    docs_storage_subnet_id = string
  })
}
