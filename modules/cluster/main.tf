locals {
  vswitch_ids     = length(var.vswitch_ids) > 0 ? split(",", join(",", var.vswitch_ids)) : length(var.vswitch_cidrs) < 1 ? [] : split(",", join(",", alicloud_vswitch.vswitches.*.id))
  kubeconfig_path = "${path.root}/${var.name}_kubeconfig.yaml"
}

data "alicloud_enhanced_nat_available_zones" "enhanced" {}

# If there is not specifying vpc_id, the module will launch a new vpc
resource "alicloud_vpc" "vpc" {
  count             = var.vpc_id == "" ? 1 : 0
  resource_group_id = var.resource_group_id
  cidr_block        = var.network_cidr
}

# According to the vswitch cidr blocks to launch several vswitches
resource "alicloud_vswitch" "vswitches" {
  count      = length(var.vswitch_ids) > 0 ? 0 : length(var.vswitch_cidrs)
  vpc_id     = var.vpc_id == "" ? join("", alicloud_vpc.vpc.*.id) : var.vpc_id
  cidr_block = element(var.vswitch_cidrs, count.index)
  zone_id    = data.alicloud_enhanced_nat_available_zones.enhanced.zones[count.index].zone_id
}

resource "alicloud_cs_managed_kubernetes" "k8s" {
  resource_group_id = var.resource_group_id
  name              = var.name
  cluster_spec      = var.cluster_spec
  version           = var.kubernetes_version

  vswitch_ids     = local.vswitch_ids
  new_nat_gateway = true
  node_cidr_mask  = var.node_cidr_mask
  proxy_mode      = var.proxy_mode
  service_cidr    = var.service_cidr
  pod_cidr        = var.pod_cidr

  addons {
    name = "csi-plugin"
  }
  addons {
    name = "csi-provisioner"
  }

  maintenance_window {
    duration         = var.maintenance_window_duration
    weekly_period    = var.maintenance_window_weekly_period
    enable           = var.maintenance_window_enable
    maintenance_time = var.maintenance_window_time
  }

  operation_policy {
    cluster_auto_upgrade {
      channel = var.cluster_auto_upgrade_channel
      enabled = var.cluster_auto_upgrade_enabled
    }
  }
}

resource "alicloud_key_pair" "cluster_key" {
  resource_group_id = var.resource_group_id
  key_pair_name     = "${var.name}-cluster-key"
}

data "alicloud_instance_types" "cloud_efficiency" {
  availability_zone    = data.alicloud_enhanced_nat_available_zones.enhanced.zones.0.zone_id
  cpu_core_count       = var.instance_types_cpu_core_count
  memory_size          = var.instance_types_memory_size
  instance_type_family = var.instance_types_family
  kubernetes_node_role = "Worker"
  system_disk_category = "cloud_efficiency"
}

resource "alicloud_cs_kubernetes_node_pool" "managed_node_pool" {
  resource_group_id    = var.resource_group_id
  node_pool_name       = var.name
  desired_size         = var.managed_node_pool_desired_size
  cluster_id           = alicloud_cs_managed_kubernetes.k8s.id
  vswitch_ids          = local.vswitch_ids
  instance_types       = data.alicloud_instance_types.cloud_efficiency.instance_types.*.id
  system_disk_category = "cloud_efficiency"
  system_disk_size     = var.worker_system_disk_size
  key_name             = alicloud_key_pair.cluster_key.key_pair_name
  multi_az_policy      = "BALANCE"

  install_cloud_monitor = var.worker_install_cloud_monitor

  # kubelet_configuration changes are ignored to prevent Terraform "dirty state" issues.
  # Without kubelet_configuration changes ignore, Terraform detects null vs empty collection changes on each apply,
  # causing unnecessary updates even if no configuration actually changed.
  lifecycle {
    ignore_changes = [kubelet_configuration]
  }
}

data "alicloud_cs_cluster_credential" "auth" {
  cluster_id                 = alicloud_cs_managed_kubernetes.k8s.id
  output_file                = local.kubeconfig_path
  temporary_duration_minutes = var.kubeconfig_temporary_duration_minutes
}