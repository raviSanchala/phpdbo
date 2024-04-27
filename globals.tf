variable "application_name" {
  description = "A unique name for the application."
}

variable "line_of_business" {
  description = "The Line of Business which owns the application."
}

variable "business_unit" {
  description = "The business unit which owns the application."
}

variable "parent_ci_id" {
  description = "The parent component id in CMDB of the configuration item."
}

variable "resource_group_name" {
  description = "The resource group in which to create the Azure resources."
}

variable "environment" {
  description = "The environment which these resources are being deployed in."
  default     = "development"
}

variable "region" {
  description = "The region to host the app in. Can be made iterable to support high-availability."
  default     = "eastus2"
}

variable "tags" {
  description = "Additional tags to apply which are not already assigned to the resource group."
  default     = {}
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_client_config" "current" {
}

locals {
  environment_tag        = lookup(local.environment_map, var.environment, "dev")
  region_name            = lookup(local.region_map, var.region).name
  region_prefix          = lookup(local.region_map, var.region).prefix
  clean_business_unit    = replace(var.business_unit, "/\\W/", "")
  clean_application_name = replace(var.application_name, "/\\W/", "")
  tags                   = merge(data.azurerm_resource_group.resource_group.tags, local.required_tags, var.tags)

  required_tags = {
    ApplicationName = var.application_name,
    LineOfBusiness  = var.line_of_business,
    BusinessUnit    = var.business_unit
    ParentCIID      = var.parent_ci_id
    Environment     = var.environment
  }

  # Standards maps
  region_map = {
    eastus        = { name = "East US", prefix = "us5" }
    eastus2       = { name = "East US 2", prefix = "us6" }
    centralus     = { name = "Central US", prefix = "us7" }
    westus2       = { name = "West US 2", prefix = "us8" }
    northeurope   = { name = "North Europe", prefix = "ie1" }
    westeurope    = { name = "West Europe", prefix = "nl1" }
    southeastasia = { name = "Southeast Asia", prefix = "sg1" }
    eastasia      = { name = "East Asia", prefix = "hk1" }
  }

  environment_map = {
    sandbox     = "sbx"
    development = "dev"
    qa          = "qa"
    uat         = "uat"
    production  = "prod"
  }

  business_map = {
    corp     = "corp"
    consumer = "cx"
    vaccines = "vx"
    pharma   = "rx"
    psc      = "psc"
  }
}
