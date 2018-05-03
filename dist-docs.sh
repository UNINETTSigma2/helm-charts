#!/bin/bash
set -e
set -o pipefail
./update-chart-repo.sh
./push.sh

