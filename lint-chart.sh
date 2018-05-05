#!/bin/sh
helm lint --strict $1 | grep -v "linted"
helm template $1 | kubeval --strict
