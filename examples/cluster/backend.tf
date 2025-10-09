terraform {
  backend "oss" {
    bucket   = "streamx-byoc-cluster-49733"
    prefix   = "terraform/state"
    region   = "eu-central-1"
    endpoint = "oss-eu-central-1.aliyuncs.com"
  }
}