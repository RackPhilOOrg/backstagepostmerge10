terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
    }
  }
}

locals {
  resourceGroup     = var.resourceGroup
  location          = lower(local.resourceGroup.locationShortcode) == "uks" ? "UKSouth" : lower(local.resourceGroup.locationShortcode) == "ukw" ? "UKWest" : lower(local.resourceGroup.locationShortcode) == "neu" ? "NorthEurope" : "WestEurope"
  resourceGroupName = lower(join("-", ["rg", local.resourceGroup.serviceBoundary, local.resourceGroup.locationShortcode, local.resourceGroup.subscriptionGuid]))
}

resource "azurerm_resource_group" "rg" {
  name     = local.resourceGroupName
  location = local.location
}
