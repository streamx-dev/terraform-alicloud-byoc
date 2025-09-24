# Alibaba Cloud bring your own cluster example

## Terraform State OSS Backend setup:
1. Navigate to [state-backend](state-backend)
2. Run `terraform init`
3. Export access [environment variables and region](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs#environment-variables) for OSS. Some regions do not allow to use public domain and require cname setup. Avoid these regions.
4. Run `terraform apply`

## BYOC clusters setup

Deployments of clusters require usage of workspaces. Each file in [workspaces](cluster/workspaces) is one cluster. This example creates two edge clusters located in Shanghai and Shenzhen. Adjust clusters definitions to your needs.

### Initialize Terraform module and workspaces

```bash
sh clusters/workers/_init-workspaces.sh
```

### Running Terraform Operations

#### 1. Deploy via Helper Script

Use the `deploy-all.sh` wrapper to deploy all clusters at once

```bash
sh _deploy-all.sh
```

---

#### 2. Manual Workspace Navigation

You can use raw terraform commands to perform well known actions. It's important to remember to include the right tfvar files while invoking the commands.

```bash

# 1) Select your workspace
terraform workspace select edge-cn-shanghai

# 2) Plan and apply with its tfvars
terraform plan -var-file=edge-cn-shanghai.tfvars
terraform apply -var-file=edge-cn-shanghai.tfvars
```

---

#### 3. Using the `tfw.sh` Wrapper

To simplify working with TFVAR files, it's recommended to use simple `tfw.sh` script.
The script auto-detects the current workspace and adds the matching `*.tfvars`:

```bash
cd clusters/workers
chmod +x tfw.sh

# Then simply:
./tfw.sh apply
```