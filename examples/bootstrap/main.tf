resource "alicloud_resource_manager_resource_group" "resource_group" {
  display_name        = var.resources_identifier
  resource_group_name = var.resources_identifier
}

resource "random_integer" "random_postfix" {
  max = 99999
  min = 10000
}

module "terraform_state_backend" {
  #  source                   = "streamx-dev/byoc/alicloud//modules/state-backend"
  #  version                  = "0.0.2"
  source                   = "../../modules/state-backend"
  bucket_name              = "${var.resources_identifier}-tf-state-${random_integer.random_postfix.result}"
  bucket_resource_group_id = alicloud_resource_manager_resource_group.resource_group.id
  tf_backend_file_path     = "${path.module}/../cluster/backend.tf"
}

resource "alicloud_ram_user" "user" {
  name     = var.resources_identifier
  comments = "User used to manage resources in ${alicloud_resource_manager_resource_group.resource_group.resource_group_name} resource group."
}

resource "alicloud_ram_access_key" "access_key" {
  user_name = alicloud_ram_user.user.name
}

data "alicloud_ram_policy_document" "streamx_byoc" {
  version = "1"

  statement {
    effect = "Allow"
    action = [
      "vpc:ListEnhanhcedNatGatewayAvailableZones",
      "vpc:DescribeVpcAttribute",
      "vpc:DescribeRouteTableList",
      "vpc:DescribeVSwitchAttributes",
      "vpc:DescribeNatGateways",

      "cs:CreateCluster",
      "cs:DescribeTaskInfo",
      "cs:DescribeClusterDetail",
    ]
    resource = ["*"]
  }
}

resource "alicloud_ram_policy" "streamx_byoc" {
  policy_name     = "${var.resources_identifier}-account-scope"
  description     = "Access required for StreamX BYOC scoped to account"
  policy_document = data.alicloud_ram_policy_document.streamx_byoc.document
}

# Attach the custom policy to the RAM user
resource "alicloud_ram_user_policy_attachment" "attach_ack_vpc_custom_policy" {
  user_name   = alicloud_ram_user.user.name
  policy_name = alicloud_ram_policy.streamx_byoc.policy_name
  policy_type = "Custom"
}

resource "alicloud_resource_manager_policy" "streamx_byoc" {
  policy_name     = "${var.resources_identifier}-resource-group-scope"
  description     = "Policy for StreamX BYOC operations scoped to resource group"
  policy_document = <<EOF
{
  "Version": "1",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateKeyPair",
        "ecs:DescribeKeyPairs",
        "ecs:DeleteKeyPairs"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "oss:PutObject",
        "oss:GetObject",
        "oss:DeleteObject",
        "oss:ListObjects",
        "oss:ListBuckets",
        "oss:GetBucket"
      ],
      "Resource": [
        "acs:oss:*:*:${module.terraform_state_backend.terraform_state_bucket}/*",
        "acs:oss:*:*:${module.terraform_state_backend.terraform_state_bucket}"
      ]
    }
  ]
}
EOF
}

data "alicloud_account" "account" {}

resource "alicloud_resource_manager_policy_attachment" "streamx_byoc" {
  policy_name       = alicloud_resource_manager_policy.streamx_byoc.policy_name
  policy_type       = "Custom"
  principal_name    = format("%s@%s.onaliyun.com", alicloud_ram_user.user.name, data.alicloud_account.account.id)
  principal_type    = "IMSUser"
  resource_group_id = alicloud_resource_manager_resource_group.resource_group.id
}

resource "alicloud_resource_manager_policy_attachment" "cs_full_access" {
  policy_name       = "AliyunCSFullAccess"
  policy_type       = "System"
  principal_name    = format("%s@%s.onaliyun.com", alicloud_ram_user.user.name, data.alicloud_account.account.id)
  principal_type    = "IMSUser"
  resource_group_id = alicloud_resource_manager_resource_group.resource_group.id
}

resource "alicloud_resource_manager_policy_attachment" "vpc_full_access" {
  policy_name       = "AliyunVPCFullAccess"
  policy_type       = "System"
  principal_name    = format("%s@%s.onaliyun.com", alicloud_ram_user.user.name, data.alicloud_account.account.id)
  principal_type    = "IMSUser"
  resource_group_id = alicloud_resource_manager_resource_group.resource_group.id
}

resource "local_sensitive_file" "tf_backend_file" {
  filename = "${path.module}/../cluster/.env"
  content  = <<EOT
export ALIBABA_CLOUD_ACCESS_KEY_ID="${alicloud_ram_access_key.access_key.id}"
export ALIBABA_CLOUD_ACCESS_KEY_SECRET="${alicloud_ram_access_key.access_key.secret}"
export TF_VAR_resource_group_id="${alicloud_resource_manager_resource_group.resource_group.id}"
EOT
}