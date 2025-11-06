variable "resource_group_id" {
  description = "Resource group in which cluster is created"
  default     = null
  type        = string
}

variable "name" {
  description = "Logical name of this ACK cluster"
  type        = string
}

variable "cluster_spec" {
  description = "ACK cluster spec (ack.standard, ack.pro.small, etc.)"
  default     = "ack.standard"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = "1.32.7-aliyun.1"
  type        = string
}

variable "maintenance_window_duration" {
  description = "Duration of the maintenance window"
  type        = string
  default     = "3h"
}

variable "maintenance_window_weekly_period" {
  description = "Maintenance cycle, you can set the values from Monday to Sunday, separated by commas when the values are multiple."
  type        = string
  default     = "Monday,Tuesday,Wednesday,Thursday,Friday"
}

variable "maintenance_window_enable" {
  description = "Enable or disable maintenance window"
  type        = bool
  default     = true
}

variable "maintenance_window_time" {
  description = "Maintenance start time in RFC3339 format"
  type        = string
  default     = "2025-07-07T02:00:00+08:00"
}

variable "cluster_auto_upgrade_channel" {
  description = "Auto upgrade channel for the cluster"
  type        = string
  default     = "patch"
}

variable "cluster_auto_upgrade_enabled" {
  description = "Enable or disable cluster auto upgrade"
  type        = bool
  default     = true
}

# leave it to empty would create a new one
variable "vpc_id" {
  description = "Existing vpc id used to create several vswitches and other resources."
  default     = ""
}

variable "network_cidr" {
  description = "The cidr block used to launch a new vpc when 'vpc_id' is not specified."
  default     = "10.0.0.0/8"
}

# leave it to empty then terraform will create several vswitches
variable "vswitch_ids" {
  description = "List of existing vswitch id."
  type        = list(string)
  default     = []
}


variable "vswitch_cidrs" {
  description = "List of cidr blocks used to create several new vswitches when 'vswitch_ids' is not specified."
  type        = list(string)
  default     = ["10.1.0.0/16", "10.2.0.0/16"]
}

# options: between 24-28
variable "node_cidr_mask" {
  description = "The node cidr block to specific how many pods can run on single node."
  default     = 24
}

# options: ipvs|iptables
variable "proxy_mode" {
  description = "Proxy mode is option of kube-proxy."
  default     = "ipvs"
}

variable "service_cidr" {
  description = "The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them."
  default     = "192.168.0.0/16"
}

variable "pod_cidr" {
  description = "The kubernetes POD cidr block."
  default     = "172.16.0.0/12"
}

variable "instance_types_cpu_core_count" {
  description = "Filter the results of instance types to a specific number of cpu cores."
  type        = number
  default     = 4
}

variable "instance_types_memory_size" {
  description = "Filter the results of instance types to a specific memory size in GB."
  type        = number
  default     = 16
}

variable "instance_types_family" {
  description = "Filter the results of instance types to a specific instance type family."
  type        = string
  default     = "ecs.g6"
}

variable "managed_node_pool_desired_size" {
  description = "Desired number of worker nodes in the managed node pool."
  type        = number
  default     = 3
}

variable "worker_system_disk_size" {
  description = "System disk size (in GB) for each worker node."
  type        = number
  default     = 40
}

variable "worker_install_cloud_monitor" {
  description = "Whether to install CloudMonitor agent on worker nodes."
  type        = bool
  default     = false
}

variable "kubeconfig_temporary_duration_minutes" {
  description = "Automatic expiration time of the returned kubeconfig."
  type        = number
  default     = null
}