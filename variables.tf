##-----------------------------------------------------------------------------
# Naming Convention
##-----------------------------------------------------------------------------

variable "resource_position_prefix" {
  type        = bool
  default     = false
  description = "If true, prefixes resource names instead of suffixing."
}

variable "custom_name" {
  type        = string
  default     = null
  description = <<EOT
Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.

- If true, the keyword is prepended: "vnet-core-dev".
- If false, the keyword is appended: "core-dev-vnet".

This helps maintain naming consistency based on organizational preferences.
EOT
}

##-----------------------------------------------------------------------------
# Global
##-----------------------------------------------------------------------------

variable "enabled" {
  type        = bool
  default     = true
  description = "Enable or disable creation of all Logic App resources."
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "Name of the resource group where resources will be deployed."
}

##-----------------------------------------------------------------------------
# Labels
##-----------------------------------------------------------------------------

variable "name" {
  type        = string
  default     = null
  description = "Base name for resources."
}

variable "location" {
  type        = string
  default     = null
  description = "Azure region where resources will be deployed."
}

variable "environment" {
  type        = string
  default     = null
  description = "Deployment environment (e.g., dev, stage, prod)."
}

variable "managedby" {
  type        = string
  default     = "terraform"
  description = "Tag to indicate the tool or team managing the resources."
}

variable "repository" {
  type        = string
  default     = "https://github.com/terraform-az-modules/terraform-azurerm-logic-app"
  description = "Repository URL or identifier for traceability."

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "deployment_mode" {
  type        = string
  default     = "terraform"
  description = "Deployment mode identifier (e.g., blue/green, canary)."
}

variable "label_order" {
  type        = list(string)
  default     = ["name", "environment", "location"]
  description = "Order of labels to be used in naming/tagging."
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to all resources."
}

##-----------------------------------------------------------------------------
# Private Endpoint
##-----------------------------------------------------------------------------

variable "enable_private_endpoint" {
  type        = bool
  default     = false
  description = "Enable or disable creation of Private Endpoint for Logic App."
}

variable "private_endpoint_subnet_id" {
  type        = string
  default     = null
  description = "Subnet ID for private endpoint"
}

variable "private_dns_zone_ids" {
  type        = string
  default     = null
  description = "Id of the private DNS Zone"
}

##-----------------------------------------------------------------------------
## Application Insights
##-----------------------------------------------------------------------------
variable "app_insights_id" {
  type        = string
  default     = null
  description = "ID of the existing Application Insights resource to use"
}

variable "read_permissions" {
  type        = list(string)
  default     = ["aggregate", "api", "draft", "extendqueries", "search"]
  description = "Read permissions for telemetry"
}

variable "app_insights_instrumentation_key" {
  type        = string
  default     = null
  description = "Instrumentation key of Application Insights"
}

variable "app_insights_connection_string" {
  type        = string
  default     = null
  description = "Connection string of App Insights"
}

variable "application_insights_enabled" {
  type        = bool
  default     = true
  description = "Enable Application Insights integration"
}

variable "app_insights_api_key_enable" {
  type        = bool
  default     = false
  description = "Enable creation of Application Insights API Key"
}

##-----------------------------------------------------------------------------
# Logic App Standard
##-----------------------------------------------------------------------------

variable "standard_enabled" {
  type        = bool
  default     = false
  description = "Enable or disable creation of Logic App Standard resources."
}

variable "os_type" {
  type        = string
  default     = null
  description = "The operating system type for the Logic App Standard."

  validation {
    condition = (
      !var.standard_enabled || (
        var.enable_app_service_enviroment == false && var.os_type == "Windows"
        ) || (
        var.enable_app_service_enviroment == true && contains(["Linux", "Windows"], var.os_type)
      )
    )
    error_message = "If enable_app_service_env is false, os_type must be 'Windows'. If enable_app_service_env is true, os_type can be 'Linux' or 'Windows'."
  }
}


variable "sku" {
  type        = string
  default     = null
  description = "The SKU for the Logic App Standard."

  validation {
    condition = (
      !var.standard_enabled || (
        var.enable_app_service_enviroment == false && contains(["WS1", "WS2", "WS3"], var.sku)
        ) || (
        var.enable_app_service_enviroment == true && contains(["I1", "I2", "I3"], var.sku)
      )
    )
    error_message = "If enable_app_service_env is false, sku must be 'WS1', 'WS2', 'WS3'. If enable_app_service_env is true, sku can be 'I1', 'I2', 'I3'."
  }
}

variable "app_service_plan_id" {
  type        = string
  default     = null
  description = "The ID of the App Service Plan to host the Logic App Standard."
}

variable "enable_app_service_enviroment" {
  type        = bool
  default     = false
  description = "Enable or Disable creation of app_service_enviroment_v3."
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "The ID of the Subnet which the App Service Environment should be connected."
}

variable "allow_new_private_endpoint_connections" {
  type        = bool
  default     = true
  description = "Should new Private Endpoint Connections be allowed."
}

variable "dedicated_host_count" {
  type        = number
  default     = null
  description = "This ASEv3 should use dedicated Hosts. Possible values are 2."
}

variable "remote_debugging_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable remote debug. Defaults to false."
}

variable "zone_redundant" {
  type        = bool
  default     = true
  description = "Deploy the ASEv3 with availability zones supported."
}

variable "internal_load_balancing_mode" {
  type        = string
  default     = null
  description = "Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment."
}

variable "cluster_setting" {
  type = map(object({
    name  = string
    value = string
  }))
  default     = {}
  description = "list of cluster setting blocks to configure App Service Environment v3 cluster-level options."
}

variable "storage_account_name" {
  type        = string
  default     = null
  description = "The name of the Storage Account associated with the Logic App Standard."
}

variable "storage_account_access_key" {
  type        = string
  default     = null
  description = "The access key for the Storage Account associated with the Logic App Standard."
}

variable "app_settings" {
  type        = any
  default     = {}
  description = "A map of App Settings to be applied to the Logic App Standard."
}

variable "use_extension_bundle" {
  type        = bool
  default     = true
  description = "Specifies whether to use the extension bundle for the Logic App Standard."
}

variable "connection_strings" {
  type        = list(map(string))
  default     = []
  description = "Connection strings for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#connection_string"
}

variable "client_affinity_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether client affinity is enabled for the Logic App Standard."
}

variable "client_certificate_mode" {
  type        = string
  default     = null
  description = "Specifies the client certificate mode."

  validation {
    condition     = var.client_certificate_mode == null || contains(["Required", "Optional", "Ignore"], var.client_certificate_mode)
    error_message = "client_certificate_mode must be Required, Optional, or Ignore."
  }
}

variable "ftp_publish_basic_authentication_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether FTP publish basic authentication is enabled for the Logic App Standard."
}

variable "https_only" {
  type        = bool
  default     = false
  description = "Specifies whether HTTPS only is enabled for the Logic App Standard."
}

variable "public_network_access" {
  type        = string
  default     = "Enabled"
  description = "Specifies whether public network access is enabled for the Logic App Standard."
}

variable "scm_publish_basic_authentication_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether SCM publish basic authentication is enabled for the Logic App Standard."
}

variable "storage_account_share_name" {
  type        = string
  default     = null
  description = "The Storage Account Share name for the Logic App Standard."
}

variable "site_config" {
  type        = any
  default     = {}
  description = "A list of site_config blocks as defined below. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config"
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
  description = "Map with identity block information."
}

variable "standard_version" {
  type        = string
  default     = "~4"
  description = "The runtime Version associated with Logic App."
}

variable "virtual_network_subnet_id" {
  type        = string
  default     = null
  description = "The ID of the Subnet to integrate with Logic App Standard."
}

variable "vnet_content_share_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether VNet content share is enabled for the Logic App Standard."
}

variable "storage_share_directory_enable" {
  type        = bool
  default     = false
  description = "Enable or disable creation of the Storage Share Directory."
}

variable "workflow_directories" {
  type        = map(any)
  default     = {}
  description = "Map of Storage Share Directories to be created."
}

variable "storage_share_file_enable" {
  type        = bool
  default     = false
  description = "Enable or disable creation of the Storage Share File."
}

variable "share_name" {
  type        = string
  default     = null
  description = "The name of the Storage Share Directory."
}

variable "storage_share_url" {
  type        = string
  default     = null
  description = "The URL of the Storage Share."
}

variable "share_file_name" {
  type        = string
  default     = null
  description = "The name of the Storage Share File."
}

variable "source_file_path" {
  type        = string
  default     = null
  description = "The path to the source file for the Storage Share File."
}

variable "content_type" {
  type        = string
  default     = null
  description = "The content type of the Storage Share File."
}

variable "workflow_files" {
  type = map(object({
    path         = string # folder inside share, "" for root
    source       = string # local path to file
    content_type = string
    content_md5  = optional(string)
  }))
  default = {
    "name" = {
      source       = null
      content_type = null
      path         = null
      content_md5  = null
    }
  }
  description = "Map of workflow files to be created in the Storage Share."
}


##-----------------------------------------------------------------------------
# Logic App Consumption
##-----------------------------------------------------------------------------

variable "consumption_enable" {
  type        = bool
  default     = false
  description = "Enable or disable creation of the Logic App Workflow."
}

variable "access_control" {
  type = object({
    action              = optional(list(string))
    content             = optional(list(string))
    trigger             = optional(list(string))
    workflow_management = optional(list(string))
  })
  default     = null
  description = "Access control configuration for Logic App Workflow triggers, actions, content, and workflow management."
}

variable "integration_service_environment_id" {
  type        = string
  default     = null
  description = "Specifies the ID of the Integration Service Environment to which the Logic App Workflow should be deployed."
}

variable "logic_app_integration_account_id" {
  type        = string
  default     = null
  description = "Specifies the ID of the Logic App Integration Account to associate with the Logic App Workflow."
}

variable "parameters" {
  type        = map(string)
  default     = {}
  description = "Specifies a map of Key-Value pairs of the Parameters to use for this Logic App Workflow. The key is the parameter name, and the value is the parameter value."
}

variable "workflow_schema" {
  type        = string
  default     = null
  description = "Specifies the Schema to use for this Logic App Workflow. Defaults to https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#."
}

variable "workflow_parameters" {
  type        = map(string)
  default     = {}
  description = "Specifies a map of Key-Value pairs of the Parameter Definitions to use for this Logic App Workflow. The key is the parameter name, and the value is a JSON encoded string of the parameter definition (see: https://docs.microsoft.com/azure/logic-apps/logic-apps-workflow-definition-language#parameters)."
}

##-----------------------------------------------------------------------------
# Logic App Triggers
##-----------------------------------------------------------------------------

variable "http_trigger_enable" {
  type        = bool
  default     = false
  description = "Enable or disable creation of the HTTP Trigger for the Logic App Workflow."
}

variable "schema" {
  type        = any
  default     = null
  description = "Specifies the Schema to use for the HTTP Trigger. Defaults to https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#."
}

variable "trigger_method" {
  type        = string
  default     = null
  description = "Specifies the HTTP methods that are allowed for the HTTP Trigger."

  validation {
    condition     = var.trigger_method == null || contains(["GET", "POST", "PUT", "DELETE", "PATCH"], var.trigger_method)
    error_message = "trigger_method must be one of GET, POST, PUT, DELETE, or PATCH."
  }
}

variable "relative_path" {
  type        = string
  default     = null
  description = "Specifies the Relative Path for the HTTP Trigger."
}

variable "recurrence_trigger_enable" {
  type        = bool
  default     = false
  description = "Enable or disable creation of the Recurrence Trigger for the Logic App Workflow."
}

variable "frequency" {
  type        = string
  default     = null
  description = "Specifies the frequency for the Recurrence Trigger (e.g., Second, Minute, Hour, Day, Week, Month, Year)."
}

variable "interval" {
  type        = number
  default     = null
  description = "Specifies the interval for the Recurrence Trigger."
}

variable "start_time" {
  type        = string
  default     = null
  description = "Specifies the start time for the Recurrence Trigger in ISO 8601 format."
}

variable "time_zone" {
  type        = string
  default     = null
  description = "Specifies the time zone for the Recurrence Trigger."
}

variable "schedule" {
  type = object({
    at_these_minutes = optional(list(number))
    at_these_hours   = optional(list(number))
    on_these_days    = optional(list(number))
  })
  default     = null
  description = "Specifies the schedule for the Recurrence Trigger."
}

variable "custom_trigger_enable" {
  type        = bool
  default     = false
  description = "Enable or disable creation of a Custom Trigger for the Logic App Workflow."
}

variable "custom_trigger_body" {
  type        = string
  default     = null
  description = "Specifies the body content for the Custom Trigger in JSON format."
}

##-----------------------------------------------------------------------------
# Logic App Actions
##-----------------------------------------------------------------------------

variable "http_action_enable" {
  type        = bool
  default     = false
  description = "Enable or Disable creation of a HTTP Action for the Logic App."
}

variable "uri" {
  type        = string
  default     = null
  description = "Specifies the URI for the HTTP Action."
}

variable "action_method" {
  type        = string
  default     = null
  description = "Specifies the HTTP methods that are allowed for the HTTP Action."

  validation {
    condition     = var.action_method == null || contains(["GET", "POST", "PUT", "DELETE", "PATCH"], var.action_method)
    error_message = "action_method must be one of GET, POST, PUT, DELETE, or PATCH."
  }
}

variable "headers" {
  type        = map(string)
  default     = {}
  description = "Specifies the headers for the HTTP Action."
}

variable "queries" {
  type        = map(string)
  default     = {}
  description = "Specifies the queries for the HTTP Action."
}

variable "run_after" {
  type = object({
    action_name   = string
    action_result = string
  })
  default     = null
  description = "Specifies the run after configuration for the HTTP Action."
}

variable "http_action_body" {
  type        = string
  default     = null
  description = "Specifies the body content for the HTTP Action in JSON format."
}

variable "custom_action_enable" {
  type        = bool
  default     = false
  description = "Enable or Disable creation of a Custom Action for the Logic App."
}

variable "custom_action_body" {
  type        = string
  default     = null
  description = "Specifies the body content for the Custom Action in JSON format."
}

##-----------------------------------------------------------------------------
# Logic App Integration Account
##-----------------------------------------------------------------------------

variable "integration_account_enable" {
  type        = bool
  default     = false
  description = "Enable or disable creation of the Logic App Integration Account."
}

variable "sku_name" {
  type        = string
  default     = "Free"
  description = "SKU name for the Logic App Integration Account."

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.sku_name)
    error_message = "sku_name must be one of Free, Standard, or Premium."
  }
}

variable "integration_account_schema_enable" {
  type        = bool
  default     = false
  description = "Enable or disable creation of a Schema for the Logic App Integration Account."
}

variable "schema_content" {
  type        = string
  default     = null
  description = "Specifies the content of the Schema for the Logic App Integration Account."
}

variable "file_name" {
  type        = string
  default     = null
  description = "Specifies the file name of the Schema for the Logic App Integration Account."
}

variable "integration_account_map_enable" {
  type        = bool
  default     = false
  description = "Enable or disable creation of a Map for the Logic App Integration Account."
}

variable "map_content" {
  type        = string
  default     = null
  description = "Specifies the content of the Map for the Logic App Integration Account."
}

variable "map_type" {
  type        = string
  default     = "Xslt"
  description = "Specifies the type of the Map for the Logic App Integration Account."

  validation {
    condition     = contains(["Liquid", "NotSpecified", "Xslt", "Xslt30", "Xslt20"], var.map_type)
    error_message = "map_type must be one of Liquid, NotSpecified, Xslt, Xslt30, or Xslt20."
  }
}

variable "integration_account_certificate_enable" {
  type        = bool
  default     = false
  description = "Enable or disable creation of a Certificate for the Logic App Integration Account."
}

variable "public_certificate" {
  type        = string
  default     = null
  description = "Specifies the public certificate in Base64 format for the Logic App Integration Account."
}

variable "key_vault_key" {
  type = object({
    key_vault_id = string
    key_name     = string
    key_version  = optional(string)
  })
  default     = null
  description = "Specifies the Key Vault Key configuration for the Logic App Integration Account."
}

variable "integration_account_partner_enable" {
  type        = bool
  default     = false
  description = "Enable or disable creation of a Partner for the Logic App Integration Account."
}

variable "business_identity" {
  type = object({
    qualifier = string
    value     = string
  })
  default     = null
  description = "Specifies the Business Identity configuration for the Logic App Integration Account."
}

variable "integration_account_agreement_enable" {
  type        = bool
  default     = false
  description = "Enable or disable creation of an Agreement for the Logic App Integration Account."
}

variable "agreement_type" {
  type        = string
  default     = "X12"
  description = "Specifies the type of the Agreement for the Logic App Integration Account."

  validation {
    condition     = contains(["X12", "Edifact", "AS2"], var.agreement_type)
    error_message = "agreement_type must be one of X12, Edifact, or AS2."
  }
}

variable "agreement_content" {
  type        = string
  default     = null
  description = "Specifies the content of the Agreement for the Logic App Integration Account."
}

variable "guest_partner_name" {
  type        = string
  default     = null
  description = "Specifies the Guest Partner Name for the Logic App Integration Account."
}

variable "host_partner_name" {
  type        = string
  default     = null
  description = "Specifies the Host Partner Name for the Logic App Integration Account."
}

variable "guest_identity" {
  type = object({
    qualifier = string
    value     = string
  })
  default     = null
  description = "Specifies the Guest Identity configuration for the Logic App Integration Account."
}

variable "host_identity" {
  type = object({
    qualifier = string
    value     = string
  })
  default     = null
  description = "Specifies the Host Identity configuration for the Logic App Integration Account."
}

##-----------------------------------------------------------------------------
## Diagnostic Setting Variables
##-----------------------------------------------------------------------------
variable "enable_diagnostic" {
  description = "Enable diagnostic settings for Linux Web App"
  type        = bool
  default     = false
}

variable "storage_account_id" {
  description = "Storage Account ID for diagnostic logs (optional)"
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for diagnostic logs"
  type        = string
  default     = null
}

variable "log_enabled" {
  description = "Enable log categories for diagnostic settings"
  type        = bool
  default     = true
}

variable "metric_enabled" {
  description = "Enable metrics for diagnostic settings"
  type        = bool
  default     = true
}