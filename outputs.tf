##-----------------------------------------------------------------------------
## Outputs
##-----------------------------------------------------------------------------

##----------------------------------------------------------------------------
## Logic App Standard
##-----------------------------------------------------------------------------

output "logic_app_ids" {
  description = "The IDs of the Logic Apps"
  value       = { for k, v in azurerm_logic_app_standard.logic_app : k => v.id }
}

output "logic_app_name" {
  description = "The IDs of the Logic Apps"
  value       = { for k, v in azurerm_logic_app_standard.logic_app : k => v.name }
}

output "logic_app_custom_domain_verification_ids" {
  description = "Custom domain verification IDs for the Logic Apps"
  value       = { for k, v in azurerm_logic_app_standard.logic_app : k => v.custom_domain_verification_id }
}

output "logic_app_default_hostnames" {
  description = "The default hostnames of the Logic Apps"
  value       = { for k, v in azurerm_logic_app_standard.logic_app : k => v.default_hostname }
}

output "logic_app_outbound_ip_addresses" {
  description = "Comma-separated list of outbound IP addresses for the Logic Apps"
  value       = { for k, v in azurerm_logic_app_standard.logic_app : k => v.outbound_ip_addresses }
}

output "logic_app_possible_outbound_ip_addresses" {
  description = "Comma-separated list of possible outbound IP addresses for the Logic Apps"
  value       = { for k, v in azurerm_logic_app_standard.logic_app : k => v.possible_outbound_ip_addresses }
}

output "logic_app_identities" {
  description = "Managed Service Identity information for the Logic Apps"
  value       = { for k, v in azurerm_logic_app_standard.logic_app : k => v.identity }
}

output "logic_app_site_credentials" {
  description = "Site-level credentials for publishing to the Logic Apps"
  value       = { for k, v in azurerm_logic_app_standard.logic_app : k => v.site_credential }
}

output "logic_app_kinds" {
  description = "The kinds of the Logic Apps"
  value       = { for k, v in azurerm_logic_app_standard.logic_app : k => v.kind }
}

##-----------------------------------------------------------------------------
## Logic App Consumption
##-----------------------------------------------------------------------------

output "logic-app_consumption_id" {
  description = "The ID of the Logic App Consumption."
  value       = try(azurerm_logic_app_workflow.main[0].id, null)
}

output "logic-app_consumption_name" {
  description = "The name of the Logic App Consumption."
  value       = try(azurerm_logic_app_workflow.main[0].name, null)
}

output "logic-app_consumption_access_endpoint" {
  description = "The Access Endpoint for the Logic App Workflow."
  value       = try(azurerm_logic_app_workflow.main[0].access_endpoint, null)
}

output "logic-app_consumption_connector_endpoint_ip_addresses" {
  description = "The list of access endpoint IP addresses of connector."
  value       = try(azurerm_logic_app_workflow.main[0].connector_endpoint_ip_addresses, null)
}

output "logic-app_consumption_connector_outbound_ip_addresses" {
  description = "The list of outbound IP addresses of connector."
  value       = try(azurerm_logic_app_workflow.main[0].connector_outbound_ip_addresses, null)
}

output "logic-app_workflow_endpoint_ip_addresses" {
  description = "The list of access endpoint IP addresses of workflow."
  value       = try(azurerm_logic_app_workflow.main[0].workflow_endpoint_ip_addresses, null)
}

output "logic-app_workflow_outbound_ip_addresses" {
  description = "The list of outgoing IP addresses of workflow."
  value       = try(azurerm_logic_app_workflow.main[0].workflow_outbound_ip_addresses, null)
}

##-----------------------------------------------------------------------------
## Triggers
##-----------------------------------------------------------------------------

output "logic-app_http_trigger_url" {
  description = "The HTTP Trigger URL for the Logic App Workflow."
  value       = try(azurerm_logic_app_trigger_http_request.main[0].callback_url, null)
}

output "logic-app_http_trigger_id" {
  description = "The HTTP Trigger ID for the Logic App Workflow."
  value       = try(azurerm_logic_app_trigger_http_request.main[0].id, null)
}

output "logic-app_recurrence_trigger_id" {
  description = "The Recurrence Trigger ID for the Logic App Workflow."
  value       = try(azurerm_logic_app_trigger_recurrence.main[0].id, null)
}

output "logic-app_custom_trigger_id" {
  description = "The Custom Trigger ID for the Logic App Workflow."
  value       = try(azurerm_logic_app_trigger_custom.main[0].id, null)
}

output "logic-app_custom_trigger_url" {
  description = "The Custom Trigger URL for the Logic App Workflow."
  value       = try(azurerm_logic_app_trigger_custom.main[0].callback_url, null)
}

##-----------------------------------------------------------------------------
## Actions
##-----------------------------------------------------------------------------
output "logic-app_http_action_id" {
  description = "The HTTP Action ID for the Logic App Workflow."
  value       = try(azurerm_logic_app_action_http.main[0].id, null)
}

output "logic-app_custom_action_id" {
  description = "The Custom Action ID for the Logic App Workflow."
  value       = try(azurerm_logic_app_action_custom.main[0].id, null)
}

##-----------------------------------------------------------------------------
## Integration Account
##-----------------------------------------------------------------------------

output "logic-app_ia_id" {
  description = "The Integration Account ID."
  value       = try(azurerm_logic_app_integration_account.main[0].id, null)
}

output "logic-app_ia_name" {
  description = "The Integration Account Name."
  value       = try(azurerm_logic_app_integration_account.main[0].name, null)
}

output "logic-app_ia_partner_ids" {
  description = "The Integration Account Partner IDs."
  value       = try(azurerm_logic_app_integration_account_partner.main.*.id, null)
}

output "logic-app_ia_schema_ids" {
  description = "The Integration Account Schema IDs."
  value       = try(azurerm_logic_app_integration_account_schema.main.*.id, null)
}

output "logic-app_ia_map_ids" {
  description = "The Integration Account Map IDs."
  value       = try(azurerm_logic_app_integration_account_map.main.*.id, null)
}

output "logic-app_ia_certificate_ids" {
  description = "The Integration Account Certificate IDs."
  value       = try(azurerm_logic_app_integration_account_certificate.main.*.id, null)
}

output "logic-app_ia_agreement_ids" {
  description = "The Integration Account Agreement IDs."
  value       = try(azurerm_logic_app_integration_account_agreement.main.*.id, null)
}