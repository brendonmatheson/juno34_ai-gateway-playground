output "ai_foundry_name" {
  description = "The name of the AI Foundry account"
  value       = azapi_resource.aigwpg_fnd.name
}

output "ai_foundry_id" {
  description = "The ID of the AI Foundry account"
  value       = azapi_resource.aigwpg_fnd.id
}

output "ai_project_name" {
  description = "The name of the AI Foundry project"
  value       = azapi_resource.aigwpg_proj.name
}

output "ai_project_id" {
  description = "The ID of the AI Foundry project"
  value       = azapi_resource.aigwpg_proj.id
}

output "gpt_4o_deployment_name" {
  description = "The name of the GPT-4o deployment"
  value       = azapi_resource.gpt_4o_deployment.name
}

output "text_embedding_deployment_name" {
  description = "The name of the text embedding deployment"
  value       = azapi_resource.text_embedding_deployment.name
}
