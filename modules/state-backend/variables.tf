variable "bucket_name" {
  description = "OOS bucket name"
  type        = string
}

variable "tf_backend_file_path" {
  description = "Terraform backend file path"
  type        = string
  default     = null
}