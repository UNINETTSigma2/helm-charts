# Helm repository



Github pages is used to automatically host a indexed repo to be used by helm of the charts above:

* <https://uninett.github.io/helm-charts/>

To add the repo to a local helm client, run:

```
helm repo add researchlab https://uninett.github.io/helm-charts
```

## Installing an app

How to install an app:

```
helm ls
helm install jupyter
helm delete DEPLOYMENT
```



## Maintaining charts

```
helm package jupyter
mv jupyter-0.2.0.tgz docs/
helm repo index docs --url https://UNINETT.github.com/helm-charts

```
