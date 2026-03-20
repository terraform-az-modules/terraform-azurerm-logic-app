provider "azurerm" {
  features {}
}

module "logic-app" {
  source = "../../"
}
