# Apache Spark

[Apache Spark](https://spark.apache.org/) is a fast and general engine for big data processing, with built-in modules for streaming, SQL, machine learning and graph processing.

### Advanced
This application creates a [Apache Spark](https://github.com/UNINETT/helm-charts/tree/master/spark) using the following Dockerfiles:
  - [quay.io/UNINETT/goidc-proxy](https://github.com/UNINETT/goidc-proxy/blob/master/Dockerfile)
  - [paalka/spark-worker](https://github.com/UNINETT/helm-charts/blob/master/spark/dockerfiles/worker/Dockerfile)
  - [paalka/spark-master](https://github.com/UNINETT/helm-charts/blob/master/spark/dockerfiles/master/Dockerfile)