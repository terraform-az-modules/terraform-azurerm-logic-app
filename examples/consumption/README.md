<!-- BEGIN_TF_DOCS -->

# Terraform Azure Logic App

This directory contains an example usage of the **terraform-azure-logic-app**. It demonstrates how to use the module with default settings or with custom configurations.

---

## 📋 Requirements

| Name      | Version   |
|-----------|-----------|
| Terraform | >= 1.6.6  |
| Azurerm   | >= 3.116.0|

---

## 🔌 Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.53.0 |


## 📦 Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_logic_app"></a> [logic_app](#module\_flexible-mysql) | ../../ | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform-az-modules/resource-group/azurerm | 1.0.3 |


---

## 🏗️ Resources

No resources are directly created in this example.

---

## 🔧 Inputs

No input variables are defined in this example.

---

## 📤 Outputs

| Name | Description |
|------|-------------|
| <a name="output_logic-app_consumption_id"></a> [logic-app\_consumption\_id](#output\_logic-app\_consumption\_id) | The ID of the Consumption Logic App. |
| <a name="output_logic-app_consumption_name"></a> [logic-app\_consumption\_name](#output\_logic-app\_consumption\_name) | The Name of the Consumption Logic App. |
| <a name="output_logic-app_integration_account_id"></a> [logic-app\_integration\_id](#output\_logic-app\_integration\_id) | The ID of the Integration Account. |
| <a name="output_http_trigger_id"></a> [http\_trigger\_id](#output\_http\_trigger\_id) | The ID of the Http Trigger Request. |
<!-- END_TF_DOCS -->
