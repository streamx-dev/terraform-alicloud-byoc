#!/usr/bin/env bash
set -euo pipefail

# Move into the cluster directory
cd "$(dirname "${BASH_SOURCE[0]}")"

# Discover workspaces from *.tfvars (excluding auto files)
WORKSPACES=()
for tfvar in workspaces/*.tfvars; do
  # skip the auto-loaded common file
  [[ "$tfvar" == *.auto.tfvars ]] && continue
  # strip the .tfvars extension to get the workspace name
  ws="$(basename "$tfvar" .tfvars)"
  WORKSPACES+=("$ws")
done

for ws in "${WORKSPACES[@]}"; do
  echo
  echo "=== Processing workspace: $ws ==="
  terraform workspace select "$ws"

  echo "> Applying rest of changes..."
  ./tfw.sh apply --auto-approve
done

echo
echo "All workspaces processed."
