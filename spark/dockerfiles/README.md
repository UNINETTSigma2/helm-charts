# Spark

This is a Docker image appropriate for running Spark on Kuberenetes. It produces three main images:
* `spark-master` - Runs a Spark master in Standalone mode and exposes a port for Spark and a port for the WebUI.
* `spark-worker` - Runs a Spark worer in Standalone mode and connects to the Spark master
* `jupyter` - Runs a jupyter web notebook and connects to the Spark master and exposes a web port

Additionally, the following image is used as a framework for the others
* `spark-base` - This base image for `spark-master` and `spark-worker` that starts nothing.
