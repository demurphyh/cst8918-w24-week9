# Configure the Terraform runtime requirements.
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    # Azure Resource Manager provider and version
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.3"
    }
  }
}

# Define providers and their config params
provider "azurerm" {
  # Leave the features block empty to accept all defaults
  features {}
}

provider "cloudinit" {
  # Configuration options
  
}

variable "labelPrefix" {
  description = "Your college username. This will form the beginning of various resource names."
  type        = string
}

variable "region" {
  description = "Azure region for deployment"
  type        = string
  default       = "canadacentral"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.labelPrefix}-A09-RG"
  location = "${var.region}"


resource "azurerm_storage_account" "storage" {
  name                     = "${lower(var.labelPrefix)}a09st" 
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"  
  
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  
  tags = {
    Environment = "A05 Assignment"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_storage_container" "container" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}