package main

import data.kubernetes

name = input.metadata.name

deny[msg] {
  kubernetes.is_deployment
  not input.spec.template.spec.securityContext.runAsNonRoot = true
  msg = sprintf("Containers in '%s' must not run as root", [name])
}

deny[msg] {
  kubernetes.is_deployment
  not input.spec.selector.matchLabels.app
  msg = sprintf("Containers in '%s' must provide app label for pod selectors", [name])
}
