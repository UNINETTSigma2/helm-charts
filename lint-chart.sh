#!/bin/bash
set -e
set -o pipefail

echo "Linting $1..."
echo "Running Helm lint..."
helm lint --strict $1 | grep -vE "linted|Lint"
helm template $1 > deployment.yaml
echo "Running kubeval lint..."
kubeval -v 1.19.15 -s https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master --strict <deployment.yaml | (grep -v " valid" || true)
echo "Running kubetest lint..."
cat deployment.yaml | conftest test -
echo "Yay, no errors when linting $1"

if [[ -f "$1/schema.yaml" ]]; then
    ./validate.py "$1/schema.yaml" "$1/values.yaml"
fi
