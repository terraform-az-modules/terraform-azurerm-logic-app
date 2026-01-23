##-----------------------------------------------------------------------------
## Outputs
##-----------------------------------------------------------------------------

##-----------------------------------------------------------------------------
## Logic App Standard   
##-----------------------------------------------------------------------------

output "logic-app_standard_name" {
  description = "The name of the Logic App."
  value       = module.logic-app.logic_app_name
}

output "logic-app_standard_id" {
  description = "The ID of the Logic App."
  value       = module.logic-app.logic_app_ids
}

output "logic-app_standard_default_hostname" {
  description = "The default hostnames of the Logic App."
  value       = module.logic-app.logic_app_default_hostnames
}

output "logic-app_standard_outbound_ip_addresses" {
  description = "The Outbound IP Addresses of the Logic App."
  value       = module.logic-app.logic_app_outbound_ip_addresses
}

output "logic-app_standard_kind" {
  description = "The kind of the Logic App."
  value       = module.logic-app.logic_app_kinds
}

