#!/bin/bash
set -e
set -o pipefail

REPO="Uninett"
API_URL="https://quay.io/api/v1"
CHART_DIR=$1
CHART_YAML=$1/Chart.yaml

IMAGES=$(grep -iqPhor "quay\.io\/$REPO\/\K[A-Za-z0-9\-]*:[a-zA-Z0-9\.\-]*" $CHART_DIR || true)
if [[ -z $IMAGES ]]; then
    exit 0
fi

for i in $IMAGES
do
    echo "img=> $i"
    IFS=':' read -a parts <<< "${i}"
    IMAGE="${parts[0]}"
    IMG_TAG="${parts[1]}"

    MANIFEST_ID="$(curl -sq -L "$API_URL/repository/$REPO/$IMAGE/tag/?specificTag=$IMG_TAG" | jq -r '.tags[0].manifest_digest')"
    LABELS="$(curl -sq -L "$API_URL/repository/$REPO/$IMAGE/manifest/$MANIFEST_ID/labels" | jq '.labels | [.[] | select( .key | startswith("pkg"))] | {"packageVersions": map({(.key): .value}) }')"
    if [[ -v $LABELS ]]; then
	echo "$LABELS" > /tmp/labels-tmp.json
	ALL_LABELS="$(jq -s '.[0] * .[1]' /tmp/labels.json /tmp/labels-tmp.json)"
	echo "$ALL_LABELS" > /tmp/labels.json
    fi
done
cat $CHART_YAML | yq '.' > /tmp/chart.json
yq -s -y '.[0] * .[1]' /tmp/chart.json /tmp/labels.json > $CHART_YAML
