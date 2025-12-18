output "apim_name" {
  description = "The name of the API Management instance"
  value       = azurerm_api_management.apim.name
}

output "apim_id" {
  description = "The ID of the API Management instance"
  value       = azurerm_api_management.apim.id
}

output "apim_gateway_url" {
  description = "The URL of the API Management gateway"
  value       = azurerm_api_management.apim.gateway_url
}

output "apim_management_api_url" {
  description = "The URL of the API Management management API"
  value       = azurerm_api_management.apim.management_api_url
}

output "apim_portal_url" {
  description = "The URL of the API Management portal"
  value       = azurerm_api_management.apim.portal_url
}
