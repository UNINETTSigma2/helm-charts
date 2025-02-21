By installing this package, a JupyterLab with various pre-installed
tools will be created. After installing, you will be able to access the
JupyterLab  using your web browser.

A [JupyterLab](http://jupyter.org/) is an open-source web application that allows you to create and share documents that contain live code, equations, visualizations and narrative text. Uses include: data cleaning and transformation, numerical simulation, statistical modeling, data visualization, machine learning, and much more.

## Features
- A browser accessible and user customisable JupyterLab
- Support for using Python, Scala and R 
- Support for distributed computing using Apache Spark

------

### Advanced
This application creates a [JupyterLab](https://github.com/UninettSigma2/helm-charts/tree/master/repos/testing/jupyter) instance using the following Dockerfiles:
  - [uninettSigma2/jupyter-spark](https://github.com/UninettSigma2/helm-charts-dockerfiles/tree/3edb4dc/jupyter-spark/Dockerfile)

#### Values
| Value name    | Description                                                                                   |
| ------------- |-----------------------------------------------------------------------------------------------|
| advanced.githubToken        | If you need to access private Github repositories, you need to specify a Github access token. |
| advanced.env.jupyterLab     | Whether or not to use JupyterLab                                                              |
| advanced.env.sparkMasterUrl | The URL to use when attempting to connect to Spark from a JupyterLab.                         |
