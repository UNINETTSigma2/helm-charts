#!/usr/bin/env python3
import jsonschema
import yaml
import sys

# HACK: These files are never closed, but is ok!
schema = yaml.safe_load(open(sys.argv[1]))
values = yaml.safe_load(open(sys.argv[2]))

jsonschema.validate(values, schema)
