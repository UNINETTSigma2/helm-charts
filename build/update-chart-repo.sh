#!/bin/bash
set -e
set -o pipefail

for repo in repos/*/
do
    repo=${repo%*/}
    charts=()
    while IFS= read -r -d $'\0'; do
	charts+=("$REPLY")
    done < <(find -- $repo/* -type d -exec sh -c '[ -f "$0"/Chart.yaml ]' '{}' \; -print0)

    for chart in "${charts[@]}"
    do
	    ./lint-chart.sh $chart
	    echo
    done

    repo_dir="docs/$repo"
    mkdir -p $repo_dir
    helm init -c
    for chart in "${charts[@]}"
    do
	echo "Packaging $chart..."
	helm package $chart --destination $repo_dir
    done
    helm repo index $repo_dir --url https://Uninett.github.com/helm-charts/$repo
done
