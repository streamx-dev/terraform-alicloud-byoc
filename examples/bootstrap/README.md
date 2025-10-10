<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_terraform_state_backend"></a> [terraform\_state\_backend](#module\_terraform\_state\_backend) | ../../modules/state-backend | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_ram_access_key.access_key](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ram_access_key) | resource |
| [alicloud_ram_policy.streamx_byoc](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ram_policy) | resource |
| [alicloud_ram_user.user](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ram_user) | resource |
| [alicloud_ram_user_policy_attachment.attach_ack_vpc_custom_policy](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ram_user_policy_attachment) | resource |
| [alicloud_resource_manager_policy.streamx_byoc](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/resource_manager_policy) | resource |
| [alicloud_resource_manager_policy_attachment.cs_full_access](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/resource_manager_policy_attachment) | resource |
| [alicloud_resource_manager_policy_attachment.streamx_byoc](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/resource_manager_policy_attachment) | resource |
| [alicloud_resource_manager_policy_attachment.vpc_full_access](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/resource_manager_policy_attachment) | resource |
| [alicloud_resource_manager_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/resource_manager_resource_group) | resource |
| [local_sensitive_file.tf_backend_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [random_integer.random_postfix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [alicloud_account.account](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/account) | data source |
| [alicloud_ram_policy_document.streamx_byoc](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/ram_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resources_identifier"></a> [resources\_identifier](#input\_resources\_identifier) | Resources identifier used in all created resources names | `string` | `"streamx-byoc"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->