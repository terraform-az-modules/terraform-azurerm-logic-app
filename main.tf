##-----------------------------------------------------------------------------
# Standard Tagging Module – Applies standard tags to all resources for traceability
##-----------------------------------------------------------------------------
module "labels" {
  source          = "terraform-az-modules/tags/azurerm"
  version         = "1.0.2"
  name            = var.custom_name == null ? var.name : var.custom_name
  location        = var.location
  environment     = var.environment
  managedby       = var.managedby
  label_order     = var.label_order
  repository      = var.repository
  deployment_mode = var.deployment_mode
  extra_tags      = var.extra_tags
}

##-----------------------------------------------------------------------------
# App Service module call
##-----------------------------------------------------------------------------

resource "azurerm_app_service_environment_v3" "main" {
  count                                  = var.enabled && var.standard_enabled && var.enable_app_service_enviroment ? 1 : 0
  name                                   = format(var.resource_position_prefix ? "app-service-env-%s" : "%s-app-service-env", local.name)
  resource_group_name                    = var.resource_group_name
  subnet_id                              = var.subnet_id
  allow_new_private_endpoint_connections = var.allow_new_private_endpoint_connections
  dedicated_host_count                   = var.dedicated_host_count
  remote_debugging_enabled               = var.remote_debugging_enabled
  zone_redundant                         = var.zone_redundant
  internal_load_balancing_mode           = var.internal_load_balancing_mode

  dynamic "cluster_setting" {
    for_each = var.cluster_setting == null ? [] : [var.cluster_setting]
    content {
      name  = cluster_setting.value.name
      value = cluster_setting.value.value
    }
  }
}

resource "azurerm_service_plan" "service_plan" {
  count               = var.enabled && var.standard_enabled && var.app_service_plan_id == null ? 1 : 0
  name                = var.resource_position_prefix ? format("asp-%s", local.name) : format("%s-asp", local.name)
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku
  worker_count = (
    var.os_type == "Linux" && var.sku == "B1" ? null :
    var.worker_count
  )
  app_service_environment_id   = try(azurerm_app_service_environment_v3.main[0].id, null)
  maximum_elastic_worker_count = var.maximum_elastic_worker_count
  per_site_scaling_enabled     = var.per_site_scaling_enabled
  zone_balancing_enabled       = var.zone_balancing_enabled
  tags                         = module.labels.tags
}

##-----------------------------------------------------------------------------
## Private Endpoint for App Service
##-----------------------------------------------------------------------------
resource "azurerm_private_endpoint" "pep" {
  count               = var.enabled && var.enable_private_endpoint ? 1 : 0
  name                = format("pe-%s", azurerm_logic_app_standard.logic_app[0].name)
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = module.labels.tags
  private_service_connection {
    name                           = var.resource_position_prefix ? format("psc-la-%s", local.name) : format("%s-psc-la", local.name)
    is_manual_connection           = false
    private_connection_resource_id = azurerm_logic_app_standard.logic_app[0].id
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = var.resource_position_prefix ? format("as-dns-zone-group-%s", local.name) : format("%s-as-dns-zone-group", local.name)
    private_dns_zone_ids = [var.private_dns_zone_ids]
  }
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
  depends_on = [azurerm_logic_app_standard.logic_app]
}

resource "azurerm_application_insights_api_key" "read_telemetry" {
  count                   = var.enabled && var.app_insights_api_key_enable ? 1 : 0
  name                    = var.resource_position_prefix ? format("appi-api-key-%s", local.name) : format("%s-appi-api-key", local.name)
  application_insights_id = var.app_insights_id
  read_permissions        = var.read_permissions
}


##-----------------------------------------------------------------------------
# Logic App Standard
##-----------------------------------------------------------------------------

resource "azurerm_logic_app_standard" "logic_app" {
  count                                    = var.enabled && var.standard_enabled ? 1 : 0
  name                                     = format(var.resource_position_prefix ? "la-stand-%s" : "%s-la-stand", local.name)
  location                                 = var.location
  resource_group_name                      = var.resource_group_name
  app_service_plan_id                      = var.app_service_plan_id == null ? azurerm_service_plan.service_plan[0].id : var.app_service_plan_id
  storage_account_name                     = var.storage_account_name
  storage_account_access_key               = var.storage_account_access_key
  use_extension_bundle                     = var.use_extension_bundle
  client_affinity_enabled                  = var.client_affinity_enabled
  client_certificate_mode                  = var.client_certificate_mode
  ftp_publish_basic_authentication_enabled = var.ftp_publish_basic_authentication_enabled
  https_only                               = var.https_only
  public_network_access                    = var.public_network_access
  scm_publish_basic_authentication_enabled = var.scm_publish_basic_authentication_enabled
  storage_account_share_name               = var.storage_account_share_name
  version                                  = var.standard_version
  virtual_network_subnet_id                = var.virtual_network_subnet_id
  vnet_content_share_enabled               = var.vnet_content_share_enabled

  # app_settings = var.staging_slot_custom_app_settings == null ? local.app_settings : merge(local.default_app_settings, var.staging_slot_custom_app_settings)
  app_settings = local.app_settings

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = lookup(connection_string.value, "name", null)
      type  = lookup(connection_string.value, "type", null)
      value = lookup(connection_string.value, "value", null)
    }
  }

  dynamic "site_config" {
    for_each = [local.site_config]
    content {
      always_on                        = lookup(site_config.value, "always_on", null)
      app_scale_limit                  = lookup(site_config.value, "app_scale_limit", null)
      auto_swap_slot_name              = lookup(site_config.value, "auto_swap_slot_name", null)
      dotnet_framework_version         = lookup(site_config.value, "dotnet_framework_version", null)
      elastic_instance_minimum         = lookup(site_config.value, "elastic_instance_minimum", null)
      ftps_state                       = lookup(site_config.value, "ftps_state", null)
      health_check_path                = lookup(site_config.value, "health_check_path", null)
      http2_enabled                    = lookup(site_config.value, "http2_enabled", null)
      scm_use_main_ip_restriction      = lookup(site_config.value, "scm_use_main_ip_restriction", null)
      scm_min_tls_version              = lookup(site_config.value, "scm_min_tls_version", null)
      scm_type                         = lookup(site_config.value, "scm_type", null)
      linux_fx_version                 = lookup(site_config.value, "linux_fx_version", null)
      min_tls_version                  = lookup(site_config.value, "min_tls_version", null)
      pre_warmed_instance_count        = lookup(site_config.value, "pre_warmed_instance_count", null)
      runtime_scale_monitoring_enabled = lookup(site_config.value, "runtime_scale_monitoring_enabled", null)
      use_32_bit_worker_process        = lookup(site_config.value, "use_32_bit_worker_process", null)
      vnet_route_all_enabled           = lookup(site_config.value, "vnet_route_all_enabled", null)
      websockets_enabled               = lookup(site_config.value, "websockets_enabled", null)

      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", null) == null ? [] : [site_config.value.cors]
        iterator = cors
        content {
          allowed_origins = cors.value.allowed_origins
        }
      }

      dynamic "ip_restriction" {
        for_each = lookup(site_config.value, "ip_restriction", null) == null ? [] : site_config.value.ip_restriction
        iterator = ip_restriction
        content {
          ip_address = ip_restriction.value.ip_address
          name       = ip_restriction.value.name
          priority   = ip_restriction.value.priority
          action     = ip_restriction.value.action

          dynamic "headers" {
            for_each = lookup(ip_restriction.value, "headers", null) == null ? [] : [ip_restriction.value.headers]
            iterator = headers
            content {
              x_azure_fdid      = headers.value.x_azure_fdid
              x_fd_health_probe = headers.value.x_fd_health_probe
              x_forwarded_for   = headers.value.x_forwarded_for
              x_forwarded_host  = headers.value.x_forwarded_host
            }
          }
        }
      }
      dynamic "scm_ip_restriction" {
        for_each = lookup(site_config.value, "scm_ip_restriction", null) == null ? [] : [site_config.value.scm_ip_restriction]
        content {
          ip_address = scm_ip_restriction.value.ip_address
          name       = scm_ip_restriction.value.name
          priority   = scm_ip_restriction.value.priority
          action     = scm_ip_restriction.value.action

          dynamic "headers" {
            for_each = lookup(scm_ip_restriction.value, "headers", null) == null ? [] : [scm_ip_restriction.value.headers]
            iterator = headers
            content {
              x_azure_fdid      = headers.value.x_azure_fdid
              x_fd_health_probe = headers.value.x_fd_health_probe
              x_forwarded_for   = headers.value.x_forwarded_for
              x_forwarded_host  = headers.value.x_forwarded_host
            }
          }
        }
      }
    }
  }
  dynamic "identity" {
    for_each = [var.identity]
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}

resource "azurerm_storage_share_directory" "workflow_dir" {
  for_each          = var.enabled && var.storage_share_directory_enable ? var.workflow_directories : {}
  name              = each.key
  storage_share_url = var.storage_share_url
  depends_on        = [azurerm_logic_app_standard.logic_app]
}

resource "azurerm_storage_share_file" "workflow_file" {
  for_each          = var.enabled && var.storage_share_file_enable ? var.workflow_files : {}
  name              = each.key
  storage_share_url = var.storage_share_url
  path              = each.value.path
  source            = each.value.source
  content_type      = each.value.content_type
  content_md5       = each.value.content_md5

  depends_on = [
    azurerm_storage_share_directory.workflow_dir, azurerm_logic_app_standard.logic_app
  ]
}

##-----------------------------------------------------------------------------
## Logic App Consumption
##-----------------------------------------------------------------------------

resource "azurerm_logic_app_workflow" "main" {
  count               = var.enabled && var.consumption_enable ? 1 : 0
  name                = format(var.resource_position_prefix ? "la-consump-%s" : "%s-la-consump", local.name)
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "access_control" {
    for_each = var.access_control == null ? [] : [var.access_control]
    content {

      dynamic "action" {
        for_each = lookup(access_control.value, "action", null) == null ? [] : [access_control.value.action]
        content {
          allowed_caller_ip_address_range = action.value.allowed_caller_ip_address_range
        }
      }

      dynamic "content" {
        for_each = lookup(access_control.value, "content", null) == null ? [] : [access_control.value.content]
        content {
          allowed_caller_ip_address_range = content.value.allowed_caller_ip_address_range
        }
      }

      dynamic "trigger" {
        for_each = lookup(access_control.value, "trigger", null) == null ? [] : [access_control.value.trigger]
        content {
          allowed_caller_ip_address_range = trigger.value.allowed_caller_ip_address_range

          dynamic "open_authentication_policy" {
            for_each = lookup(trigger.value, "open_authentication_policy", null) == null ? [] : [trigger.value.open_authentication_policy]
            content {
              name = open_authentication_policy.value.name

              claim {
                name  = open_authentication_policy.value.claim.name
                value = open_authentication_policy.value.claim.value
              }
            }
          }
        }
      }
      dynamic "workflow_management" {
        for_each = lookup(access_control.value, "workflow_management", null) == null ? [] : [access_control.value.workflow_management]
        content {
          allowed_caller_ip_address_range = workflow_management.value.allowed_caller_ip_address_range
        }
      }
    }
  }
  integration_service_environment_id = var.integration_service_environment_id
  logic_app_integration_account_id   = var.logic_app_integration_account_id
  workflow_schema                    = var.workflow_schema
  workflow_parameters                = var.workflow_parameters
  parameters                         = var.parameters
}

##-----------------------------------------------------------------------------
## Triggers
##-----------------------------------------------------------------------------

resource "azurerm_logic_app_trigger_http_request" "main" {
  count         = var.enabled && var.http_trigger_enable ? 1 : 0
  name          = format(var.resource_position_prefix ? "la-trig-http-%s" : "%s-la-trig-http", local.name)
  logic_app_id  = azurerm_logic_app_workflow.main[0].id
  schema        = var.schema
  method        = var.trigger_method
  relative_path = var.relative_path
  depends_on    = [azurerm_logic_app_workflow.main[0]]
}

resource "azurerm_logic_app_trigger_recurrence" "main" {
  count        = var.enabled && var.recurrence_trigger_enable ? 1 : 0
  name         = format(var.resource_position_prefix ? "la-trig-rec-%s" : "%s-la-trig-rec", local.name)
  logic_app_id = azurerm_logic_app_workflow.main[0].id
  frequency    = var.frequency
  interval     = var.interval
  start_time   = var.start_time
  time_zone    = var.time_zone
  dynamic "schedule" {
    for_each = var.schedule == null ? [] : [var.schedule]
    content {
      at_these_minutes = schedule.value["at_these_minutes"]
      at_these_hours   = schedule.value["at_these_hours"]
      on_these_days    = schedule.value["on_these_days"]
    }
  }
  depends_on = [azurerm_logic_app_workflow.main[0]]
}

resource "azurerm_logic_app_trigger_custom" "main" {
  count        = var.enabled && var.custom_trigger_enable ? 1 : 0
  name         = format(var.resource_position_prefix ? "la-trig-custom-%s" : "%s-la-trig-custom", local.name)
  logic_app_id = azurerm_logic_app_workflow.main[0].id
  body         = var.custom_trigger_body
  depends_on   = [azurerm_logic_app_standard.logic_app[0], azurerm_logic_app_workflow.main[0]]
}

##-----------------------------------------------------------------------------
## Actions
##-----------------------------------------------------------------------------

resource "azurerm_logic_app_action_custom" "main" {
  count        = var.enabled && var.custom_action_enable ? 1 : 0
  name         = format(var.resource_position_prefix ? "la-action-custom-%s" : "%s-la-action-custom", local.name)
  logic_app_id = azurerm_logic_app_workflow.main[0].id
  body         = var.custom_action_body
  depends_on   = [azurerm_logic_app_workflow.main[0]]
}

resource "azurerm_logic_app_action_http" "main" {
  count        = var.enabled && var.http_action_enable ? 1 : 0
  name         = format(var.resource_position_prefix ? "la-action-http-%s" : "%s-la-action-http", local.name)
  logic_app_id = azurerm_logic_app_workflow.main[0].id
  method       = var.action_method
  uri          = var.uri
  body         = var.http_action_body
  headers      = var.headers
  queries      = var.queries

  dynamic "run_after" {
    for_each = var.run_after == null ? [] : [var.run_after]
    content {
      action_name   = run_after.value.action_name
      action_result = run_after.value.action_result
    }
  }
  depends_on = [azurerm_logic_app_workflow.main[0]]
}

##-----------------------------------------------------------------------------
## Integration Account Association
##-----------------------------------------------------------------------------

resource "azurerm_logic_app_integration_account" "main" {
  count                              = var.enabled && var.integration_account_enable ? 1 : 0
  name                               = format(var.resource_position_prefix ? "la-ia-%s" : "%s-la-ia", local.name)
  location                           = var.location
  resource_group_name                = var.resource_group_name
  sku_name                           = var.sku_name
  integration_service_environment_id = var.integration_service_environment_id
}

resource "azurerm_logic_app_integration_account_schema" "main" {
  count                    = var.enabled && var.integration_account_schema_enable ? 1 : 0
  name                     = format(var.resource_position_prefix ? "la-iaschema-%s" : "%s-la-iaschema", local.name)
  integration_account_name = azurerm_logic_app_integration_account.main[0].name
  resource_group_name      = var.resource_group_name
  content                  = var.schema_content
  file_name                = var.file_name
  depends_on               = [azurerm_logic_app_integration_account.main[0]]
}

resource "azurerm_logic_app_integration_account_map" "main" {
  count                    = var.enabled && var.integration_account_map_enable ? 1 : 0
  name                     = format(var.resource_position_prefix ? "la-iamap-%s" : "%s-la-iamap", local.name)
  integration_account_name = azurerm_logic_app_integration_account.main[0].name
  resource_group_name      = var.resource_group_name
  content                  = var.map_content
  map_type                 = var.map_type
  depends_on               = [azurerm_logic_app_integration_account.main[0]]
}

resource "azurerm_logic_app_integration_account_certificate" "main" {
  count                    = var.enabled && var.integration_account_certificate_enable ? 1 : 0
  name                     = format(var.resource_position_prefix ? "la-iacert-%s" : "%s-la-iacert", local.name)
  integration_account_name = azurerm_logic_app_integration_account.main[0].name
  resource_group_name      = var.resource_group_name
  public_certificate       = var.public_certificate

  dynamic "key_vault_key" {
    for_each = var.key_vault_key == null ? [] : [var.key_vault_key]
    content {
      key_vault_id = key_vault_key.value.key_vault_id
      key_name     = key_vault_key.value.key_name
      key_version  = key_vault_key.value.key_version
    }
  }

  depends_on = [azurerm_logic_app_integration_account.main[0]]
}

resource "azurerm_logic_app_integration_account_partner" "main" {
  count                    = var.enabled && var.integration_account_partner_enable ? 1 : 0
  name                     = format(var.resource_position_prefix ? "la-ia-partner-%s" : "%s-la-ia-partner", local.name)
  integration_account_name = azurerm_logic_app_integration_account.main[0].name
  resource_group_name      = var.resource_group_name

  dynamic "business_identity" {
    for_each = var.business_identity
    content {
      qualifier = business_identity.value.qualifier
      value     = business_identity.value.value
    }
  }

  depends_on = [azurerm_logic_app_integration_account.main[0]]
}

resource "azurerm_logic_app_integration_account_agreement" "main" {
  count                    = var.enabled && var.integration_account_agreement_enable ? 1 : 0
  name                     = format(var.resource_position_prefix ? "la-ia-agreement-%s" : "%s-la-ia-agreement", local.name)
  integration_account_name = azurerm_logic_app_integration_account.main[0].name
  resource_group_name      = var.resource_group_name
  agreement_type           = var.agreement_type
  content                  = var.agreement_content
  guest_partner_name       = var.guest_partner_name
  host_partner_name        = var.host_partner_name

  dynamic "guest_identity" {
    for_each = var.guest_identity
    content {
      qualifier = guest_identity.value.qualifier
      value     = guest_identity.value.value
    }
  }

  dynamic "host_identity" {
    for_each = var.host_identity
    content {
      qualifier = host_identity.value.qualifier
      value     = host_identity.value.value
    }
  }

  depends_on = [azurerm_logic_app_integration_account.main[0]]
}

##-----------------------------------------------------------------------------
# Diagnostic Setting for Logic App
##-----------------------------------------------------------------------------

resource "azurerm_monitor_diagnostic_setting" "web_app_diag" {
  count = var.enabled && var.enable_diagnostic ? 1 : 0
  name  = var.resource_position_prefix ? format("diag-la-%s", local.name) : format("%s-diag-la", local.name)

  # Dynamically select target resource based on OS type
  target_resource_id         = var.standard_enabled ? azurerm_logic_app_standard.logic_app[0].id : azurerm_logic_app_workflow.main[0].id
  storage_account_id         = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = var.log_enabled ? ["allLogs"] : []
    content {
      category_group = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = var.metric_enabled ? ["AllMetrics"] : []
    content {
      category = enabled_metric.value
    }
  }

  lifecycle {
    ignore_changes = [enabled_log, enabled_metric]
  }
}