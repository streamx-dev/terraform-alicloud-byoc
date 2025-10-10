<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | ~> 1.260.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster"></a> [cluster](#module\_cluster) | ../../modules/cluster | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alicloud_region"></a> [alicloud\_region](#input\_alicloud\_region) | ACK cluster region | `string` | n/a | yes |
| <a name="input_cluster_spec"></a> [cluster\_spec](#input\_cluster\_spec) | ACK cluster spec (ack.standard, ack.pro.small, etc.) | `string` | `"ack.standard"` | no |
| <a name="input_instance_types_cpu_core_count"></a> [instance\_types\_cpu\_core\_count](#input\_instance\_types\_cpu\_core\_count) | Filter the results of instance types to a specific number of cpu cores. | `number` | `4` | no |
| <a name="input_instance_types_memory_size"></a> [instance\_types\_memory\_size](#input\_instance\_types\_memory\_size) | Filter the results of instance types to a specific memory size in GB. | `number` | `16` | no |
| <a name="input_kubeconfig_temporary_duration_minutes"></a> [kubeconfig\_temporary\_duration\_minutes](#input\_kubeconfig\_temporary\_duration\_minutes) | Automatic expiration time of the returned kubeconfig. | `number` | `null` | no |
| <a name="input_managed_node_pool_desired_size"></a> [managed\_node\_pool\_desired\_size](#input\_managed\_node\_pool\_desired\_size) | Desired number of worker nodes in the managed node pool. | `number` | `2` | no |
| <a name="input_network_cidr"></a> [network\_cidr](#input\_network\_cidr) | The cidr block used to launch a new vpc when 'vpc\_id' is not specified. | `string` | `"10.0.0.0/8"` | no |
| <a name="input_node_cidr_mask"></a> [node\_cidr\_mask](#input\_node\_cidr\_mask) | The node cidr block to specific how many pods can run on single node. | `number` | `24` | no |
| <a name="input_pod_cidr"></a> [pod\_cidr](#input\_pod\_cidr) | The kubernetes POD cidr block. | `string` | `"172.16.0.0/12"` | no |
| <a name="input_proxy_mode"></a> [proxy\_mode](#input\_proxy\_mode) | Proxy mode is option of kube-proxy. | `string` | `"ipvs"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | Resource group in which cluster is created | `string` | n/a | yes |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them. | `string` | `"192.168.0.0/16"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Existing vpc id used to create several vswitches and other resources. | `string` | `""` | no |
| <a name="input_vswitch_cidrs"></a> [vswitch\_cidrs](#input\_vswitch\_cidrs) | List of cidr blocks used to create several new vswitches when 'vswitch\_ids' is not specified. | `list(string)` | <pre>[<br/>  "10.1.0.0/16",<br/>  "10.2.0.0/16"<br/>]</pre> | no |
| <a name="input_vswitch_ids"></a> [vswitch\_ids](#input\_vswitch\_ids) | List of existing vswitch id. | `list(string)` | `[]` | no |
| <a name="input_worker_install_cloud_monitor"></a> [worker\_install\_cloud\_monitor](#input\_worker\_install\_cloud\_monitor) | Whether to install CloudMonitor agent on worker nodes. | `bool` | `false` | no |
| <a name="input_worker_system_disk_size"></a> [worker\_system\_disk\_size](#input\_worker\_system\_disk\_size) | System disk size (in GB) for each worker node. | `number` | `40` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->