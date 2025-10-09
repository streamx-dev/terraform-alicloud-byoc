# -----------------------------
# OSS bucket for Terraform state
# -----------------------------
resource "alicloud_oss_bucket" "tf_state" {
  bucket = var.bucket_name
  resource_group_id = var.bucket_resource_group_id
}

resource "alicloud_oss_bucket_acl" "tf_state-acl" {
  bucket = alicloud_oss_bucket.tf_state.bucket
  acl    = "private"
}

data "alicloud_regions" "available" {
  current = true
}

# -----------------------------
# Terraform backend config file
# -----------------------------
resource "local_file" "tf_backend_file" {
  count    = var.tf_backend_file_path == null ? 0 : 1
  filename = var.tf_backend_file_path
  content  = templatefile("${path.module}/config/backend_template.tftpl.tf", {
    bucket   = alicloud_oss_bucket.tf_state.bucket
    region   = data.alicloud_regions.available.regions.0.id
    endpoint = alicloud_oss_bucket.tf_state.extranet_endpoint
  })
}
