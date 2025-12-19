terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {
}

# Import resource group details from 01_rg stack
data "terraform_remote_state" "rg" {
  backend = "local"

  config = {
    path = "../01_rg/terraform.tfstate"
  }
}

variable "ai_foundry_name" {
  description = "Name of the AI Foundry account"
  type        = string
}

variable "ai_project_name" {
  description = "Name of the AI Foundry project"
  type        = string
}

# AI Foundry Account (AI Services) - using azapi to enable project management
resource "azapi_resource" "aigwpg_fnd" {
  type                      = "Microsoft.CognitiveServices/accounts@2025-04-01-preview"
  name                      = var.ai_foundry_name
  location                  = data.terraform_remote_state.rg.outputs.resource_group_location
  parent_id                 = data.terraform_remote_state.rg.outputs.resource_group_id
  schema_validation_enabled = false
  
  body = {
    kind = "AIServices"
    properties = {
      customSubDomainName        = var.ai_foundry_name
      disableLocalAuth           = true
      publicNetworkAccess        = "Enabled"
      allowProjectManagement     = true
      networkAcls = {
        defaultAction = "Allow"
      }
    }
    sku = {
      name = "S0"
    }
  }
  
  identity {
    type = "SystemAssigned"
  }
  
  lifecycle {
    ignore_changes = [body.tags]
  }
}

# AI Foundry Project
resource "azapi_resource" "aigwpg_proj" {
  schema_validation_enabled = false
  body = {
    properties = {
      description = "Default project created with the resource"
      displayName = var.ai_project_name
    }
  }
  location  = data.terraform_remote_state.rg.outputs.resource_group_location
  name      = var.ai_project_name
  parent_id = azapi_resource.aigwpg_fnd.id
  type      = "Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview"
  
  identity {
    type = "SystemAssigned"
  }
}

# Model Deployment: gpt-4o
resource "azapi_resource" "gpt_4o_deployment" {
  schema_validation_enabled = false
  body = {
    properties = {
      currentCapacity = 225
      model = {
        format  = "OpenAI"
        name    = "gpt-4o"
        version = "2024-08-06"
      }
      raiPolicyName        = "Microsoft.DefaultV2"
      versionUpgradeOption = "OnceNewDefaultVersionAvailable"
    }
    sku = {
      capacity = 225
      name     = "GlobalStandard"
    }
  }
  name      = "gpt-4o"
  parent_id = azapi_resource.aigwpg_fnd.id
  type      = "Microsoft.CognitiveServices/accounts/deployments@2025-04-01-preview"
  
  depends_on = [azapi_resource.aigwpg_proj]
}

# Model Deployment: text-embedding-3-large
resource "azapi_resource" "text_embedding_deployment" {
  schema_validation_enabled = false
  body = {
    properties = {
      currentCapacity = 150
      model = {
        format  = "OpenAI"
        name    = "text-embedding-3-large"
        version = "1"
      }
      raiPolicyName        = "Microsoft.DefaultV2"
      versionUpgradeOption = "OnceNewDefaultVersionAvailable"
    }
    sku = {
      capacity = 150
      name     = "GlobalStandard"
    }
  }
  name      = "text-embedding-3-large"
  parent_id = azapi_resource.aigwpg_fnd.id
  type      = "Microsoft.CognitiveServices/accounts/deployments@2025-04-01-preview"
  
  depends_on = [azapi_resource.gpt_4o_deployment]
}
