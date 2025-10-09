variable "bucket_name" {
  description = "OOS bucket name"
  type        = string
}

variable "bucket_resource_group_id" {
  description = "Resource group id where OOS bucket is created"
  type        = string
  default     = null
}

variable "tf_backend_file_path" {
  description = "Terraform backend file path"
  type        = string
  default     = null
}