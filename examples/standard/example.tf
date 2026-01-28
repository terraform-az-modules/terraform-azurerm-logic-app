provider "azurerm" {
  features {}
}

locals {
  name        = "logapp"
  environment = "test"
  location    = "centralindia"
  label_order = ["name", "environment", "location"]
}

##-----------------------------------------------------------------------------
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------
module "resource_group" {
  source  = "terraform-az-modules/resource-group/azurerm"
  version = "1.0.3"

  name                     = local.name
  environment              = local.environment
  label_order              = local.label_order
  location                 = local.location
  resource_position_prefix = false
}

##-----------------------------------------------------------------------------
## Virtual Network
##-----------------------------------------------------------------------------
module "vnet" {
  source              = "terraform-az-modules/vnet/azurerm"
  version             = "1.0.3"
  name                = local.name
  environment         = local.environment
  label_order         = local.label_order
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

##-----------------------------------------------------------------------------
## Subnets
##-----------------------------------------------------------------------------
module "subnet" {
  source               = "terraform-az-modules/subnet/azurerm"
  version              = "1.0.1"
  environment          = local.environment
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name
  subnets = [
    {
      name            = "subnet1"
      subnet_prefixes = ["10.0.1.0/24"]
    },
    {
      name            = "subnet2"
      subnet_prefixes = ["10.0.2.0/24"]
      # Delegation
      delegations = [
        {
          name = "Microsoft.Web/serverFarms"
          service_delegations = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = []
              # Note: In some versions, 'actions' might not be required or is implicit
            }
          ]
        }
      ]
    }
  ]
  enable_route_table = true
  route_tables = [
    {
      name = "pub"
      routes = [
        {
          name           = "rt-test"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
        }
      ]
    }
  ]
}

##-----------------------------------------------------------------------------
## Subnet for Private Endpoint
##-----------------------------------------------------------------------------
module "subnet-ep" {
  source               = "terraform-az-modules/subnet/azurerm"
  version              = "1.0.1"
  environment          = local.environment
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name
  subnets = [
    {
      name            = "sub3"
      subnet_prefixes = ["10.0.3.0/24"]
    }
  ]
  enable_route_table = false
}

##-----------------------------------------------------------------------------
## Log Analytics
##-----------------------------------------------------------------------------
module "log-analytics" {
  source                      = "terraform-az-modules/log-analytics/azurerm"
  version                     = "1.0.2"
  name                        = local.name
  environment                 = local.environment
  label_order                 = local.label_order
  resource_group_name         = module.resource_group.resource_group_name
  location                    = module.resource_group.resource_group_location
  log_analytics_workspace_sku = "PerGB2018"
}

##-----------------------------------------------------------------------------
## Private DNS Zone
##-----------------------------------------------------------------------------
module "private-dns-zone" {
  source              = "terraform-az-modules/private-dns/azurerm"
  version             = "1.0.4"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  label_order         = local.label_order
  name                = local.name
  environment         = local.environment
  private_dns_config = [
    {
      resource_type = "azure_web_apps"
      vnet_ids      = [module.vnet.vnet_id]
    },
  ]
}

##-----------------------------------------------------------------------------
## Application Insights
##-----------------------------------------------------------------------------
module "application-insights" {
  source                     = "terraform-az-modules/application-insights/azurerm"
  version                    = "1.0.1"
  name                       = local.name
  environment                = local.environment
  label_order                = local.label_order
  resource_group_name        = module.resource_group.resource_group_name
  location                   = module.resource_group.resource_group_location
  workspace_id               = module.log-analytics.workspace_id
  log_analytics_workspace_id = module.log-analytics.workspace_id
  web_test_enable            = false
}

##-----------------------------------------------------------------------------
# Storage Account module call
##-----------------------------------------------------------------------------

module "storage-account" {
  source  = "terraform-az-modules/storage/azurerm"
  version = "1.0.0"

  name                     = local.name
  environment              = local.environment
  label_order              = local.label_order
  location                 = module.resource_group.resource_group_location
  resource_group_name      = module.resource_group.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  file_shares = [
    { name = "fileshare", quota = "50" },
  ]
}


##-----------------------------------------------------------------------------
# Logic App module call
##-----------------------------------------------------------------------------

module "logic-app" {

  source                     = "../.."
  standard_enabled           = true
  name                       = local.name
  environment                = local.environment
  label_order                = local.label_order
  location                   = module.resource_group.resource_group_location
  resource_group_name        = module.resource_group.resource_group_name
  storage_account_name       = module.storage-account.storage_account_name
  storage_account_access_key = module.storage-account.storage_primary_access_key
  storage_account_share_name = keys(module.storage-account.file_shares)[0]
  os_type                    = "Windows"
  sku                        = "WS1"

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY        = module.application-insights.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = module.application-insights.connection_string
    FUNCTIONS_WORKER_RUNTIME              = "node"
    WEBSITE_NODE_DEFAULT_VERSION          = "~22"
  }

  site_config = {
    application_insights_key = module.application-insights.instrumentation_key
    azure_files = {
      account_name = module.storage-account.storage_account_name # Storage account containing workflows
      share_name   = keys(module.storage-account.file_shares)[0] # File share with host.json and workflow folder
      access_key   = module.storage-account.storage_primary_access_key
      mount_path   = "/home/site/wwwroot"
    }
  }

  https_only                     = true
  enable_private_endpoint        = true
  private_endpoint_subnet_id     = module.subnet-ep.subnet_ids["sub3"]                         # Use private endpoint subnet
  virtual_network_subnet_id      = module.subnet.subnet_ids["subnet2"]                         # Delegated subnet for logic app integration
  private_dns_zone_ids           = module.private-dns-zone.private_dns_zone_ids.azure_web_apps # Reference the private DNS zone IDs for logic app
  public_network_access          = "Enabled"                                                   # Checkov suggested enhancement
  enable_diagnostic              = true
  app_insights_id                = module.application-insights.app_insights_id
  log_analytics_workspace_id     = module.log-analytics.workspace_id
  storage_share_directory_enable = true
  storage_share_file_enable      = true
  storage_share_url              = "https://${module.storage-account.storage_account_name}.file.core.windows.net/${keys(module.storage-account.file_shares)[0]}"
  workflow_directories = {
    "site/wwwroot/MyWorkflow" = {}
  }
  workflow_files = {
    "workflow.json" = {
      path         = "site/wwwroot/MyWorkflow" # inside folder MyWorkflow
      source       = "./workflow/MyWorkflow/workflow.json"
      content_type = "application/json"
    }
  }

  depends_on = [module.storage-account, module.subnet["subnet2"]]
}