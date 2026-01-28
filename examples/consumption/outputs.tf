##-----------------------------------------------------------------------------
## Logic App Consumption
##-----------------------------------------------------------------------------

output "logic-app_consumption_id" {
  description = "The ID of the Logic App Consumption."
  value       = module.logic-app.logic-app_consumption_id
}

output "logic-app_consumption_name" {
  description = "The name of the Logic App Consumption."
  value       = module.logic-app.logic-app_consumption_name
}

##-----------------------------------------------------------------------------
## Logic App Triggers
##-----------------------------------------------------------------------------

output "http_trigger_id" {
  description = "The ID of the HTTP Trigger of Logic App."
  value       = module.logic-app.logic-app_http_trigger_id
}

output "custom_trigger_id" {
  description = "The ID of the Custom Trigger of Logic App."
  value       = module.logic-app.logic-app_custom_trigger_id
}

output "recurrence_trigger_id" {
  description = "The ID of the Recurrence Trigger of Logic App."
  value       = module.logic-app.logic-app_recurrence_trigger_id
}

#-------------------------------------------------------------------------------
## Integration Account Outputs
##-------------------------------------------------------------------------------

output "logic-app_integration_account_id" {
  description = "The ID of the Logic App Integration Account."
  value       = module.logic-app.logic-app_ia_id
}