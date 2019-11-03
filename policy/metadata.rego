package main

import data.kubernetes

name = input.metadata.name
kind = input.kind

pod_labels {
  input.spec.template.metadata.labels["app"]
  input.spec.template.metadata.labels["chart"]
  input.spec.template.metadata.labels["release"]
  input.spec.template.metadata.labels["heritage"]
}

deny[msg] {
  kubernetes.is_deployment
  not pod_labels

  msg = sprintf("missing recommended Helm labels in pod template for Deployment %s", [name])
}

annotations {
    input.metadata.annotations["appstore.uninett.no/contact_email"]
}

deny[msg] {
  not annotations
  msg = sprintf("%s/%s must the appstore.uninett.no/contact_email annotation", [kind, name])
}

deny[msg] {
  kubernetes.is_deployment
  not input.spec.template.metadata.annotations["appstore.uninett.no/contact_email"]

  msg = sprintf("missing 'appstore.uninett.no/contact_email' annotation in pod template for Deployment %s", [name])
}

labels {
    input.metadata.labels["app"]
    input.metadata.labels["chart"]
    input.metadata.labels["release"]
    input.metadata.labels["heritage"]
}

deny[msg] {
  not input.kind = "RoleBinding"
  not input.kind = "Role"
  not input.kind = "ServiceAccount"
  not labels
  msg = sprintf("%s/%s missing recommend Helm labels", [kind, name])
}
