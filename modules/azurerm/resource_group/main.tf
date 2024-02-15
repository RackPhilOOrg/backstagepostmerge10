terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
    }
  }
    # Update this block with the location of your terraform state file
  backend "azurerm" {
    resource_group_name  = "rg-terraformpostmerg10"
    storage_account_name = "tfpostmoerge10"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
    use_oidc             = true
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
