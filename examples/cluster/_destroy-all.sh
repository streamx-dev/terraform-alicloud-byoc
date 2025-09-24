#!/usr/bin/env bash
set -euo pipefail

# Move into the cluster directory
cd "$(dirname "${BASH_SOURCE[0]}")"

workspaces=()
for tfvar in workspaces/*.tfvars; do
  # skip the auto-loaded common file
  [[ "$tfvar" == *.auto.tfvars ]] && continue
  # strip the .tfvars extension to get the workspace name
  ws="$(basename "$tfvar" .tfvars)"
  workspaces+=("$ws")
done

for ws in "${workspaces[@]}"; do
  echo
  echo "=== Processing workspace: $ws ==="
  terraform workspace select "$ws"

  echo "> Destroying the cluster..."
  ./tfw.sh destroy --auto-approve
done

echo
echo "All workspaces processed."
