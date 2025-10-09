resource "random_integer" "random_postfix" {
  max = 99999
  min = 10000
}

module "terraform_state_backend" {
  source = "../../modules/state-backend"
  bucket_name = "streamx-byoc-cluster-${random_integer.random_postfix.result}"
  tf_backend_file_path = "${path.module}/../cluster/backend.tf"
}