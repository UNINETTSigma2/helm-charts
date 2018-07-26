# Jupyter notebook

[Jupyter Notebook](http://jupyter.org/) is an open-source web application that allows you to create and share documents that contain live code, equations, visualizations and narrative text. Uses include: data cleaning and transformation, numerical simulation, statistical modeling, data visualization, machine learning, and much more.

### Advanced
This application creates a [Jupyter Notebook](https://github.com/Uninett/helm-charts/tree/master/jupyter) instance using the following Dockerfiles:
  - [quay.io/uninett/jupyter-spark](https://github.com/Uninett/helm-charts-dockerfiles/tree/0f20926/jupyter-spark/Dockerfile)

#### Values
| Value name    | Description |
| ------------- | ----------------------------------------------------------------------------------------------------------- |
| advanced.githubToken        | If you need to access private Github repositories, you need to specify a Github access token. |
| advanced.env.jupyterLab     | Whether or not to use JupyterLab                                                              |
| advanced.env.sparkMasterUrl | The URL to use when attempting to connect to Spark from a Jupyter notebook.                   |
