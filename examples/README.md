# StreamX BYOC Terraform Setup (Alibaba Cloud)

This example demonstrates how to **bootstrap** and **provision multi-region ACK clusters** on **Alibaba Cloud** using **StreamX Bring-Your-Own-Cloud (BYOC)** Terraform modules.

It shows how to:

* Initialize and configure Alibaba Cloud resources (OSS backend, RAM user, policies)
* Deploy ACK clusters across multiple regions using **Terraform workspaces**
* Automate deployment and destruction with shell helpers

---

## 📦 Using the Example

**Copy the contents of the `examples/` directory** into your own workspace or Git repository.

For example:

```bash
mkdir -p ~/streamx-byoc-demo
cp -r examples/* ~/streamx-byoc-demo/
cd ~/streamx-byoc-demo
```

---

## 🚀 Overview

### 1. `bootstrap/`

Sets up the **Alibaba Cloud environment**:

* Creates a **Resource Group**
* Sets up an **OSS bucket** for Terraform state
* Creates a **RAM user** and **access key**
* Grants permissions required for cluster provisioning
* Generates two important files for the cluster step:

    * `../cluster/backend.tf`
    * `../cluster/.env`

### 2. `cluster/`

Provisions ACK clusters in **multiple regions** using Terraform **workspaces**.
Each workspace corresponds to a `.tfvars` file under `workspaces/`.

Example:

* `edge-cn-shanghai.tfvars` → workspace `edge-cn-shanghai`
* `edge-cn-shenzhen.tfvars` → workspace `edge-cn-shenzhen`

Helper scripts automate initialization, deployment, and cleanup.

---

## 🧰 Prerequisites

* [Terraform ≥ 1.6](https://developer.hashicorp.com/terraform/downloads)
* Alibaba Cloud account permissions to manage:

    * Resource Groups
    * OSS Buckets
    * RAM Users & Policies

---

## ⚙️ Setup Instructions

### Step 1. Go to the Bootstrap Directory

```bash
cd bootstrap
```

---

### Step 2. Configure Variables

Create a file `terraform.tfvars`:

```hcl
resources_identifier = "streamx-byoc-demo"
```

Choose a unique identifier — it will prefix your resource names.

---

### Step 3. Initialize and Apply Bootstrap

```bash
terraform init
terraform apply
```

This will:

* Create the Resource Group
* Create an OSS bucket for Terraform remote state
* Create and configure the RAM user
* Generate:

    * `../cluster/backend.tf`
    * `../cluster/.env`

---

### Step 4. Verify Output Files

#### `cluster/.env`

```bash
export ALIBABA_CLOUD_ACCESS_KEY_ID="..."
export ALIBABA_CLOUD_ACCESS_KEY_SECRET="..."
export TF_VAR_resource_group_id="rg-xxxxx"
```

#### `cluster/backend.tf`

Defines Terraform backend using the created OSS bucket.

---

### Step 5. Initialize Cluster Workspaces

Move to the cluster directory and load environment variables:

```bash
cd ../cluster
source .env
```

Then initialize Terraform workspaces:

```bash
./_init-workspaces.sh
```

This script:

* Runs `terraform init` (if needed)
* Creates workspaces for each `.tfvars` file in `workspaces/`
* Lists available workspaces

Example output:

```
✓ workspace 'edge-cn-shanghai' exists
✓ workspace 'edge-cn-shenzhen' exists

To continue, select an active workspace:
  terraform workspace select <workspace-name>

Then run Terraform commands with:
  ./tfw.sh plan
  ./tfw.sh apply
```

---

### Step 6. Deploy Clusters

#### Option A — Deploy a single workspace (cluster)

1. Select a workspace:

```bash
terraform workspace select edge-cn-shanghai
./tfw.sh apply
```

#### Option B — Deploy all workspaces at once

```bash
./_deploy-all.sh
```

Each workspace is selected and applied in sequence.
Example output:
```
=== Processing workspace: edge-cn-shanghai ===
> Applying rest of changes...

=== Processing workspace: edge-cn-shenzhen ===
> Applying rest of changes...

All workspaces processed.
```

---

### Step 7. Access the Clusters

After successful deployment, you can obtain each cluster’s `kubeconfig` from `streamx-byoc-*_kubeconfig.yaml` files.

---
## Cleanup instructions
### Step 1. Destroy Clusters

#### Option A — Destroy a specific workspace

```bash
terraform workspace select edge-cn-shanghai
./tfw.sh destroy
```

#### Option B — Destroy all clusters

```bash
./_destroy-all.sh
```

This script iterates through all workspaces and runs `terraform destroy` automatically.

---

### Step 2. Destroy bootstrapped **Alibaba Cloud environment**

When all clusters are deleted, you can clean up the entire environment:

```bash
cd ../bootstrap
terraform destroy
```

---

## 🔐 Security Notes

* The `.env` file contains **sensitive access keys** — **never commit it** to version control. For production or shared environments, it is recommended to store these values in a dedicated secrets engine, such as HashiCorp Vault, and inject them securely into the deployment environment.
* The created RAM user is **scoped to your Resource Group**.

---

## 🧩 Helper Script Summary

| Script                | Description                                                                 |
| --------------------- | --------------------------------------------------------------------------- |
| `_init-workspaces.sh` | Initializes Terraform and creates workspaces based on `workspaces/*.tfvars` |
| `_deploy-all.sh`      | Iterates over all workspaces and applies changes                            |
| `_destroy-all.sh`     | Iterates over all workspaces and destroys clusters                          |
| `tfw.sh`              | Wrapper for Terraform commands (ensures consistent options/envs)            |

---

## 🏁 Workflow Summary

| Step | Description                         | Command                                             |
| ---- | ----------------------------------- |-----------------------------------------------------|
| 1    | Bootstrap Alibaba Cloud environment | `cd bootstrap && terraform init && terraform apply` |
| 2    | Initialize workspaces               | `cd ../cluster && ./_init-workspaces.sh`            |
| 3    | Deploy all clusters                 | `./_deploy-all.sh`                                  |

---

## 🧾 Cluster Configuration

Each `.tfvars` file in the `workspaces/` directory corresponds to **one ACK cluster**.
These files allow you to **customize all variables** of the cluster module, including VPC, vSwitches, CIDR ranges, cluster spec, node pool sizes, and other configuration options.

Example `workspaces/edge-cn-shanghai.tfvars`:

```hcl
vpc_id          = "vpc-xxxxxx"
vswitch_ids     = ["vsw-xxxxxx"]
vswitch_cidrs   = ["192.168.1.0/24"]
network_cidr    = "192.168.0.0/16"
service_cidr    = "172.21.0.0/20"
pod_cidr        = "172.22.0.0/16"
cluster_spec    = "ack.pro.small"
instance_types_cpu_core_count  = 4
instance_types_memory_size     = 8192
managed_node_pool_desired_size = 2
worker_system_disk_size        = 100
worker_install_cloud_monitor   = true
```

Add more `.tfvars` files under `workspaces/` to deploy **additional regional clusters**, each fully configurable via its own file.

---

✅ **You’re now ready to deploy StreamX BYOC clusters using Terraform on Alibaba Cloud.**
This example setup can be safely copied, versioned, and customized within your organization’s infrastructure repository.