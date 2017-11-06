#!/bin/bash
set -e
charts=( "dokuwiki" "spark/spark" "wordpress" "etherpad" "jupyter" )

for chart in "${charts[@]}"
do
    echo "Linting $chart..."
    helm lint --strict $chart
    echo
done

for chart in "${charts[@]}"
do
    echo "Packaging $chart..."
    helm package $chart --destination docs/
    echo
done
helm repo index docs --url https://UNINETT.github.com/helm-charts
