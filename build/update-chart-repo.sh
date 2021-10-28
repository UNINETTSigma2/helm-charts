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

    for chart_dir in "${charts[@]}"
    do
	    echo "Attempting to get image labels for $chart_dir..."
	    ./get-labels.sh $chart_dir || true
        if [[ $chart_dir == repos/testing/* ]];
        then
	        ./lint-chart.sh "$chart_dir" || true
        else
            ./lint-chart.sh "$chart_dir"
        fi
	    echo
    done

    repo_dir="docs/$repo"
    mkdir -p "$repo_dir"
# No init in helm3
#    helm init -c
    for chart_dir in "${charts[@]}"
    do
	   echo "Packaging $chart_dir..."
	   helm package $chart_dir --destination $repo_dir
    done
    helm repo index repos/$repo_dir --url https://Uninett.github.io/helm-charts/$repo
done

