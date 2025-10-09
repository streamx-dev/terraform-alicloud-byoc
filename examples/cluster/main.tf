locals {
  cluster_name = "streamx-byoc-${terraform.workspace}"
}

module "cluster" {
  source  = "streamx-dev/byoc/alicloud//modules/cluster"
  version = "0.0.2"

  resource_group_id                     = var.resource_group_id
  name                                  = local.cluster_name
  cluster_spec                          = var.cluster_spec
  vpc_id                                = var.vpc_id
  network_cidr                          = var.network_cidr
  vswitch_ids                           = var.vswitch_ids
  vswitch_cidrs                         = var.vswitch_cidrs
  node_cidr_mask                        = var.node_cidr_mask
  proxy_mode                            = var.proxy_mode
  service_cidr                          = var.service_cidr
  pod_cidr                              = var.pod_cidr
  instance_types_cpu_core_count         = var.instance_types_cpu_core_count
  instance_types_memory_size            = var.instance_types_memory_size
  managed_node_pool_desired_size        = var.managed_node_pool_desired_size
  worker_system_disk_size               = var.worker_system_disk_size
  worker_install_cloud_monitor          = var.worker_install_cloud_monitor
  kubeconfig_temporary_duration_minutes = var.kubeconfig_temporary_duration_minutes
}