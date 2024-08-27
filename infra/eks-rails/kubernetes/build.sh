#!/usr/bin/env bash
set -eux

kubectl slice --help > /dev/null
command -v envsubst >/dev/null 2>&1 || { echo >&2 "envsubst is required but it's not installed. Aborting."; exit 1; }

cd "$(dirname "$0")"

while read -r target_path; do
  rm -rf $target_path/build
  mkdir -p $target_path/build
  kubectl kustomize --load-restrictor LoadRestrictionsNone $target_path | \
    envsubst | \
    kubectl slice --template='{{if .metadata.namespace}}ns-{{.metadata.namespace}}/{{end}}kind-{{.kind | lower}}/{{.metadata.name}}.yaml' --output-dir=$target_path/build
done <<EOF
all/overlays/production
rails-app/overlays/production
EOF

echo "Build completed successfully"
