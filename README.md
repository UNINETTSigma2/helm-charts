[![Build Status](https://travis-ci.org/Uninett/helm-charts.svg?branch=master)](https://travis-ci.org/Uninett/helm-charts)

# Helm repository
Github pages is used to automatically host the Helm repos in this git repo.
Currently, two Helm repos are in use.
- Stable: all charts in this repo should be usable in production
- Testing: charts that are currently being testing, and are thus not ready for production

To add the stable repo to a local helm client, run:

```
helm repo add researchlab https://uninett.github.io/helm-charts/repos/stable
```

### Documentation
- [Wiki](https://github.com/Uninett/helm-charts/wiki/)
- [Adding a new package](https://github.com/Uninett/helm-charts/wiki/Creating-a-new-package)
