#!/bin/sh

for chart in "dokuwiki" "spark/spark" "wordpress" "etherpad" "jupyter"
do
    helm package $chart --destination docs/
done
helm repo index docs --url https://UNINETT.github.com/helm-charts
