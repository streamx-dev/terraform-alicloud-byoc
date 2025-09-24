# -----------------------------
# Outputs
# -----------------------------
output "terraform_state_bucket" {
  value = alicloud_oss_bucket.tf_state.bucket
}
output "terraform_state_region" {
  value = data.alicloud_regions.available.regions.0.id
}