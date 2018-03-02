#!/bin/bash

# Strict mode
set -euo pipefail

jupyter lab --config $NOTEBOOKS_CONFIG_DIR/jupyter_notebook_config.py --ip 0.0.0.0 --port 8888
