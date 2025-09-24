#!/usr/bin/env bash
set -euo pipefail

# Move into the cluster directory
cd "$(dirname "${BASH_SOURCE[0]}")"

# 1) Must already be in a workspace
if ! ws=$(terraform workspace show 2>/dev/null); then
  echo "ERROR: Unable to detect Terraform workspace. Run 'terraform init' and select or create a workspace first." >&2
  exit 1
fi

# 2) Ensure tfvars exists for that workspace
TFVARS_FILE="workspaces/${ws}.tfvars"
if [[ ! -f "$TFVARS_FILE" ]]; then
  echo "ERROR: Variable file '$TFVARS_FILE' not found for workspace '$ws'." >&2
  exit 1
fi

# 3) Delegate to Terraform, always passing the var-file
echo "→ terraform $* -var-file=$TFVARS_FILE"
terraform "$@" -var-file="$TFVARS_FILE"
