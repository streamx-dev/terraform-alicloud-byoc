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

  operation_policy {
    cluster_auto_upgrade {
      enabled = true
      channel = "stable"
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

  install_cloud_monitor = var.worker_install_cloud_monitor

  # Default empty values (e.g., [] for lists, {} for maps) are used here to prevent Terraform "dirty state" issues.
  # Without defaults, Terraform detects null vs empty collection changes on each apply,
  # causing unnecessary updates even if no configuration actually changed.
  kubelet_configuration {
    allowed_unsafe_sysctls     = []
    cluster_dns                = []
    eviction_hard              = {}
    eviction_soft              = {}
    eviction_soft_grace_period = {}
    feature_gates = {
      RotateKubeletServerCertificate = true
    }
    system_reserved = var.kubelet_configuration_system_reserved
    kube_reserved   = var.kubelet_configuration_kube_reserved
  }
}

data "alicloud_cs_cluster_credential" "auth" {
  cluster_id                 = alicloud_cs_managed_kubernetes.k8s.id
  output_file                = local.kubeconfig_path
  temporary_duration_minutes = var.kubeconfig_temporary_duration_minutes
}