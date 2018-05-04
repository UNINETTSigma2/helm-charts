#!/bin/bash
set -e
set -o pipefail

charts=()
while IFS= read -r -d $'\0'; do
    charts+=("$REPLY")
done < <(find -- * -type d -exec sh -c '[ -f "$0"/Chart.yaml ]' '{}' \; -print0)

for chart in "${charts[@]}"
do
	$HOME/helm lint --strict $chart | grep -v "linted"
	echo
done

$HOME/helm init -c
for chart in "${charts[@]}"
do
    echo "Packaging $chart..."
    $HOME/helm package $chart --destination docs/
done
$HOME/helm repo index docs --url https://UNINETT.github.com/helm-charts
