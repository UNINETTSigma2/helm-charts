#!/bin/bash
set -e
set -o pipefail
charts=( "dokuwiki" "spark" "wordpress" "etherpad" "jupyter" "jupyterhub" "jupyterlab" "deep-learning-tools" )

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
