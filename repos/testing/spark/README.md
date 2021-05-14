By installing this package, an [Apache Spark](https://spark.apache.org/)
cluster will be created. After installing, you will be able to access the Apache Spark
cluster dashboard through your web browser.

[Apache Spark](https://spark.apache.org/) is a fast and general engine for big
data processing, with built-in modules for streaming, SQL, machine learning
and graph processing.

## Features
- Support for connecting other applications (such Jupyter notebooks) to the Spark cluster
- A user-accessible cluster dashboard

------

### Advanced
This application creates a [Apache Spark](https://github.com/Uninett/helm-charts/tree/master/repos/testing/spark) cluster using the following Dockerfile:
  - [uninett/jupyter-spark](https://github.com/Uninett/helm-charts-dockerfiles/tree/6405497/jupyter-spark/Dockerfile)


#### Values
| Value name    | Description |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| advanced.masterImage | The Docker image to use when creating the master.    |
| advanced.workerImage | The Docker image to use when creating worker(s).     |
| advanced.master.machineType | Determines how much resources will be allocated to the master. |
| advanced.worker.replicas | The amount of workers to create in the cluster. |
| advanced.worker.machineType | Determines how much resources will be allocated to each worker. |
