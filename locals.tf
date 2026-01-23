##-----------------------------------------------------------------------------
## Locals
##-----------------------------------------------------------------------------
locals {
  name = var.custom_name != null ? var.custom_name : module.labels.id
  default_site_config = {
    always_on                               = "true"
    scm_minimum_tls_version                 = "1.2"
    container_registry_use_managed_identity = false
  }
  site_config = merge(local.default_site_config, var.site_config)

  default_app_settings = var.application_insights_enabled ? {
    APPLICATION_INSIGHTS_IKEY             = var.app_insights_instrumentation_key
    APPINSIGHTS_INSTRUMENTATIONKEY        = var.app_insights_instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.app_insights_connection_string
  } : {}
  app_settings = merge(local.default_app_settings, var.app_settings)
}