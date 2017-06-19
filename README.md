# Helm repository



How to install an app:

```
helm ls
helm install jupyter
helm delete DEPLOYMENT
```



## Maintaining charts

```
helm package jupyter
mv jupyter-0.1.0.tgz docs/
helm repo index docs --url https://UNINETT.github.com/helm-charts

```
