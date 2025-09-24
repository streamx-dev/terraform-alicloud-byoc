output "private_key_openssh" {
  description = "Private SSH key to access the VM"
  value       = alicloud_key_pair.cluster_key.key_file
  sensitive   = true
}

output "kubeconfig" {
  description = "ACK Cluster kubeconfig file"
  value       = data.alicloud_cs_cluster_credential.auth.kube_config
  sensitive   = true
}

output "kubeconfig_expiration" {
  description = "ACK Cluster kubeconfig expiration time"
  value       = data.alicloud_cs_cluster_credential.auth.expiration
  sensitive   = true
}

output "kubeconfig_path" {
  value = local.kubeconfig_path
}
