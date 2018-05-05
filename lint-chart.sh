#!/bin/bash
set -e
set -o pipefail

echo "Linting $1..."
echo "Running Helm lint..."
helm lint --strict $1 | grep -vE "linted|Lint"
echo "Running Kubeval lint..."
helm template $1 | kubeval --strict | (grep -v " valid" || true)
echo "Yay, no errors when linting $1"
