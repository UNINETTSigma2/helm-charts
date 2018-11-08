#!/bin/bash
set -e
set -o pipefail

REPO="Uninett"
API_URL="https://quay.io/api/v1"
CHART_DIR=$1

IMAGES=$(grep -iPhor "quay\.io\/$REPO\/\K[A-Za-z0-9\-]*:[a-zA-Z0-9\.\-]*" $CHART_DIR || true)
if [[ -z $IMAGES ]]; then
    exit 0
fi

echo "{}" > labels.json
for i in $IMAGES
do
    IFS=':' read -a parts <<< "${i}"
    IMAGE="${parts[0]}"
    IMG_TAG="${parts[1]}"

    MANIFEST_ID="$(curl -sq -L "$API_URL/repository/$REPO/$IMAGE/tag/?specificTag=$IMG_TAG" | jq -r '.tags[0].manifest_digest')"
    if [[ "$MANIFEST_ID" = "null" ]]; then
	echo "Failed to obtain manifest ID from https://quay.io/repository/$REPO/$IMAGE:$IMG_TAG"
	echo "Make sure that the image exists"
	exit 1
    fi
    LABELS="$(curl -sq -L "$API_URL/repository/$REPO/$IMAGE/manifest/$MANIFEST_ID/labels" | jq '.labels | [.[] | select( .key | startswith("pkg"))] | map({(.key):  .value}) | add | . //= {} | {"packageVersions": . }')"
    echo "$LABELS" > labels-tmp.json
    ALL_LABELS="$(jq -s '.[0] * .[1]' labels.json labels-tmp.json)"
    echo "$ALL_LABELS" > labels.json
done

mv labels.json $CHART_DIR/package_versions.json
