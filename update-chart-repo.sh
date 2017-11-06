#!/bin/bash
set -e
charts=( "dokuwiki" "spark/spark" "wordpress" "etherpad" "jupyter" )

for chart in "${charts[@]}"
do
    helm lint --strict $chart | grep -v "linted"
    echo
done

for chart in "${charts[@]}"
do
    echo "Packaging $chart..."
    helm package $chart --destination docs/
done
helm repo index docs --url https://UNINETT.github.com/helm-charts
