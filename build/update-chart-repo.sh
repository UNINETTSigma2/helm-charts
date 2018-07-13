#!/bin/bash
set -e
set -o pipefail

charts=()
while IFS= read -r -d $'\0'; do
    charts+=("$REPLY")
done < <(find -- * -type d -exec sh -c '[ -f "$0"/Chart.yaml ]' '{}' \; -print0)

for chart in "${charts[@]}"
do
        ./lint-chart.sh $chart
	echo
done

helm init -c
for chart in "${charts[@]}"
do
    echo "Packaging $chart..."
    helm package $chart --destination docs/
done
helm repo index docs --url https://Uninett.github.com/helm-charts
