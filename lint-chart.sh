#!/bin/sh
$HOME/helm lint --strict $1 | grep -v "linted"
$HOME/helm template $1 | $HOME/kubeval --strict
