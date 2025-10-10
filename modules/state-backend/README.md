<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | ~> 1.260.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | ~> 1.260.1 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_oss_bucket.tf_state](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/oss_bucket) | resource |
| [alicloud_oss_bucket_acl.tf_state-acl](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/oss_bucket_acl) | resource |
| [local_file.tf_backend_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [alicloud_regions.available](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | OOS bucket name | `string` | n/a | yes |
| <a name="input_bucket_resource_group_id"></a> [bucket\_resource\_group\_id](#input\_bucket\_resource\_group\_id) | Resource group id where OOS bucket is created | `string` | `null` | no |
| <a name="input_tf_backend_file_path"></a> [tf\_backend\_file\_path](#input\_tf\_backend\_file\_path) | Terraform backend file path | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_terraform_state_bucket"></a> [terraform\_state\_bucket](#output\_terraform\_state\_bucket) | ----------------------------- Outputs ----------------------------- |
| <a name="output_terraform_state_region"></a> [terraform\_state\_region](#output\_terraform\_state\_region) | n/a |
<!-- END_TF_DOCS -->