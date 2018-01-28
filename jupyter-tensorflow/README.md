# Jupyter notebook with Tensorflow integration
This package create a Jupyter notebook that can be used with a GPU enabled version of Tensorflow.
[Jupyter Notebook](http://jupyter.org/) is an open-source web application that
allows you to create and share documents that contain live code, equations,
visualizations and narrative text. Uses include: data cleaning and
transformation, numerical simulation, statistical modeling, data
visualization, machine learning, and much more.

### Advanced
This application creates a [Jupyter Notebook](https://github.com/UNINETT/helm-charts/tree/master/jupyter) instance using the following Dockerfiles:
  - [quay.io/UNINETT/goidc-proxy](https://github.com/UNINETT/goidc-proxy/blob/master/Dockerfile)
  - [gcr.io/tensorflow/tensorflow:latest-gpu](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/docker/Dockerfile.gpu)