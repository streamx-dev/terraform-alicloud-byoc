#!/usr/bin/env bash
set -euo pipefail

# Move into the cluster directory
cd "$(dirname "${BASH_SOURCE[0]}")"

# 1) Initialize Terraform once
if [[ ! -d .terraform ]]; then
  echo "→ terraform init"
  terraform init -input=false
fi

# Discover workspaces from *.tfvars (excluding auto files)
WORKSPACES=()
for tfvar in workspaces/*.tfvars; do
  # skip the auto-loaded common file
  [[ "$tfvar" == *.auto.tfvars ]] && continue
  # strip the .tfvars extension to get the workspace name
  ws="$(basename "$tfvar" .tfvars)"
  WORKSPACES+=("$ws")
done

# Create each workspace if it doesn't exist
for ws in "${WORKSPACES[@]}"; do
  if terraform workspace list -no-color | grep -qx "[* ]*${ws}"; then
    echo "✓ workspace '$ws' exists"
  else
    echo "→ creating workspace '$ws'"
    terraform workspace new "$ws" -no-color >/dev/null
  fi
done

echo
echo "To continue, select an active workspace:"
echo "  terraform workspace select <workspace-name>"
echo
echo "Then run Terraform commands with the wrapper, for example:"
echo "  ./tfw.sh plan"
echo "  ./tfw.sh apply"
echo