terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
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

provider "azurerm" {
  features {}
  use_oidc = true
}

locals {
  boundary = var.boundary.config
}

module "resource_group" {
  source   = "./modules/azurerm/resource_group"
  for_each = { for s in local.boundary.resourceGroup : s.resourceGroupId => s }
  resourceGroup = merge(
    {
      config                   = each.value
      locationShortcode        = local.boundary.locationShortcode
      serviceBoundaryShortcode = local.boundary.serviceBoundaryShortcode
      serviceBoundary          = local.boundary.serviceBoundary
      subscriptionGuid         = local.boundary.subscriptionGuid
    }
  )
}
