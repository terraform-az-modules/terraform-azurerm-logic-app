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
| <a name="module_log-analytics"></a> [log-analytics](#module\_log-analytics) | terraform-az-modules/log-analytics/azurerm | 1.0.2 |
| <a name="module_private_dns"></a> [private\_dns](#module\_private\_dns) | terraform-az-modules/private-dns/azurerm | 1.0.4 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform-az-modules/resource-group/azurerm | 1.0.3 |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | terraform-az-modules/subnet/azurerm | 1.0.1 |
| <a name="module_application_insights"></a> [application_insights](#module\_application_insights) | terraform-az-modules/application_insights/azurerm | 1.0.1 |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | terraform-az-modules/vnet/azurerm | 1.0.3 |
| <a name="module_storage"></a> [vnet](#module\_storage) | terraform-az-modules/storage/azurerm | 1.0.0 |


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
| <a name="output_logic-app_standard_id"></a> [logic-app\_standard\_id](#output\_logic-app\_standard\_id) | The ID of the Standard Logic App. |
| <a name="output_logic-app_standard_name"></a> [logic-app\_standard\_name](#output\_logic-app\_standard\_name) | The Name of the Standard Logic App. |
| <a name="output_logic-app_standard_default_hostname"></a> [logic-app\_standard\_default_hostname](#output\_logic-app\_standard\_default_hostname) | The Default Name of Standard Logic App. |
| <a name="output_logic-app_standard_outbound_ip_addresses"></a> [logic-app\_standard\_outbount_ip_addressses](#output\_logic-app\_standard\_outbound_ip_addresses) | The Outbound Ip Addresses of Standard Logic App. |
| <a name="output_logic-app_standard_kind"></a> [logic-app\_standard\_kind](#output\_logic-app\_standard\_kind) | The Kind of the Standard Logic App. |
<!-- END_TF_DOCS -->
