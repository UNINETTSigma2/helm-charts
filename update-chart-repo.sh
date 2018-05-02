#!/bin/bash
set -e
set -o pipefail
charts=( "dokuwiki" "spark" "wordpress" "etherpad" "jupyter" "jupyterhub" "jupyterlab" "deep-learning-tools" )

for chart in "${charts[@]}"
do
    $HOME/helm lint --strict $chart | grep -v "linted"
    echo
done

for chart in "${charts[@]}"
do
    echo "Packaging $chart..."
    $HOME/helm package $chart --destination docs/
done
$HOME/helm repo index docs --url https://UNINETT.github.com/helm-charts
