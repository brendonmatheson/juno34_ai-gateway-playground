terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Import resource group details from 01_rg stack
data "terraform_remote_state" "rg" {
  backend = "local"

  config = {
    path = "../01_rg/terraform.tfstate"
  }
}

variable "apim_name" {
  description = "Name of the API Management instance"
  type        = string
}

variable "publisher_name" {
  description = "The name of the publisher/company"
  type        = string
}

variable "publisher_email" {
  description = "The email address of the publisher/company"
  type        = string
}

resource "azurerm_api_management" "apim" {
  name                = var.apim_name
  location            = data.terraform_remote_state.rg.outputs.resource_group_location
  resource_group_name = data.terraform_remote_state.rg.outputs.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email

  sku_name = "Developer_1"

  tags = {
    Environment = "Development"
  }
}
