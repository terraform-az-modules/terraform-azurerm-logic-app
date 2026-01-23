provider "azurerm" {
  features {}
}

locals {
  name        = "log-app"
  environment = "test"
  label_order = ["name", "location", "environment"]
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
  location                 = "centralindia"
  resource_position_prefix = false
}

##-----------------------------------------------------------------------------
# Logic App module call
##-----------------------------------------------------------------------------

module "logic-app" {
  source              = "../.."
  consumption_enable  = true
  name                = local.name
  environment         = local.environment
  label_order         = local.label_order
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  http_trigger_enable = true
  trigger_method      = "POST"
  relative_path       = "/"
  schema = jsonencode({
    type       = "object",
    properties = { name = { type = "string" } }
  })

  http_action_enable         = true
  action_method              = "POST"
  http_action_body           = jsonencode({ message = "Hello World" })
  uri                        = "http://example.com/some-webhook"
  integration_account_enable = true
  sku_name                   = "Standard"
}