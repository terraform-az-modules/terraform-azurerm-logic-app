# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v2.0.0] - 2026-04-22
### :bug: Bug Fixes
- [`e159396`](https://github.com/terraform-az-modules/terraform-azurerm-logic-app/commit/e159396d9a69a1a527cd810254fad894d501dff7) - consolidate versions.tf, remove provider_meta, upgrade to azurerm >= 4.0 *(commit by [@anmolnagpal](https://github.com/anmolnagpal))*
- [`992bcf5`](https://github.com/terraform-az-modules/terraform-azurerm-logic-app/commit/992bcf5a6d5c08a02b291cbf33eb6951f6adcf50) - replace version placeholder in example versions.tf with >= 4.0 *(commit by [@anmolnagpal](https://github.com/anmolnagpal))*

### :wrench: Chores
- [`011e6c9`](https://github.com/terraform-az-modules/terraform-azurerm-logic-app/commit/011e6c951f6d58e8906bc1e55fafa013bac33aef) - **deps**: bump actions/checkout from 4 to 6 *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`54d4a51`](https://github.com/terraform-az-modules/terraform-azurerm-logic-app/commit/54d4a515cb487a29956c6023eef0ce60a2655311) - **deps**: bump terraform-linters/setup-tflint from 4 to 6 *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`090814f`](https://github.com/terraform-az-modules/terraform-azurerm-logic-app/commit/090814f6e52cd20ca055531a418e75a87c620397) - **deps**: bump hashicorp/setup-terraform from 3 to 4 *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`0b3a658`](https://github.com/terraform-az-modules/terraform-azurerm-logic-app/commit/0b3a658ba6684ca2d803a63693648a3f1189516c) - add provider_meta for API usage tracking *(PR [#10](https://github.com/terraform-az-modules/terraform-azurerm-logic-app/pull/10) by [@clouddrove-ci](https://github.com/clouddrove-ci))*
- [`cd1be99`](https://github.com/terraform-az-modules/terraform-azurerm-logic-app/commit/cd1be99a9929029c1e6ca8ece9dd6f1cdd462809) - polish module with basic example, changelog, and version fixes *(PR [#11](https://github.com/terraform-az-modules/terraform-azurerm-logic-app/pull/11) by [@clouddrove-ci](https://github.com/clouddrove-ci))*
- [`f53e821`](https://github.com/terraform-az-modules/terraform-azurerm-logic-app/commit/f53e8219fd30adeab5f9c17341851651398869b5) - **deps**: bump actions/checkout from 3 to 6 *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*


## [1.0.0] - 2026-03-20

### Changes
- Add provider_meta for API usage tracking
- Add terraform tests and pre-commit CI workflow
- Add SECURITY.md, CONTRIBUTING.md, .releaserc.json
- Standardize pre-commit to antonbabenko v1.105.0
- Set provider: none in tf-checks for validate-only CI
- Bump required_version to >= 1.10.0
[v2.0.0]: https://github.com/terraform-az-modules/terraform-azurerm-logic-app/compare/v1.0.0...v2.0.0
