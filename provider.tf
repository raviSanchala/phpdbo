variable "subscription_id" { default = null }
variable "client_id" { default = null }
variable "client_secret" { default = null }
variable "tenant_id" { default = null }

provider "azurerm" {
  features {}
  skip_provider_registration = true
  subscription_id            = var.subscription_id
  client_id                  = var.client_id
  tenant_id                  = var.tenant_id
  client_secret              = var.client_secret
}
