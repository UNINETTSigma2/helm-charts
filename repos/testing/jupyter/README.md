By installing this package, a Jupyter notebook with various pre-installed
tools will be created. After installing, you will be able to access the
Jupyter notebook using your web browser.

A [Jupyter Notebook](http://jupyter.org/) is an open-source web application that allows you to create and share documents that contain live code, equations, visualizations and narrative text. Uses include: data cleaning and transformation, numerical simulation, statistical modeling, data visualization, machine learning, and much more.

## Features
- A browser accessible and user customisable Jupyter notebook
- Support for using Python, Scala and R within the notebook
- Support for distributed computing using Apache Spark

------

### Advanced
This application creates a [Jupyter Notebook](https://github.com/UninettSigma2/helm-charts/tree/master/repos/testing/jupyter) instance using the following Dockerfiles:
  - [uninettSigma2/jupyter-spark](https://github.com/UninettSigma2/helm-charts-dockerfiles/tree/fbbf65f/jupyter-spark/Dockerfile)

#### Values
| Value name    | Description |
| ------------- | ----------------------------------------------------------------------------------------------------------- |
| advanced.githubToken        | If you need to access private Github repositories, you need to specify a Github access token. |
| advanced.env.jupyterLab     | Whether or not to use JupyterLab                                                              |
| advanced.env.sparkMasterUrl | The URL to use when attempting to connect to Spark from a Jupyter notebook.                   |
