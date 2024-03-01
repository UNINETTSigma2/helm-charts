By installing this package, an instance of Jupyterhub capable of creating new
Jupyter notebook instances will be created. After installing, you will be able
access Jupyterhub through your web browser, and other logged in users will be
able to create Jupyter notebooks by visiting Jupyterhub.

[Jupyterhub](https://jupyterhub.readthedocs.io/en/latest/) can for instance be
used to serve notebooks to a class of students, a corporate data science
group, or a scientific research group.

## Features
- The ability to access and administer the notebooks of each user
- Support for sharing data among the users
- The ability to use a custom Docker image when spawning new notebooks

------

### Advanced
This application uses the following Dockerfile:
  - [Jupyter Hub Server](https://github.com/UninettSigma2/helm-charts-dockerfiles/tree/4a4b359/jupyterhub/server/Dockerfile)
  - [User Notebook Server](https://github.com/UNINETTSigma2/helm-charts-dockerfiles/blob/21d3e398c4e364cb432d9fd08ef8aa68dc9fae23/jupyterhub/singleuser/Dockerfile)


#### Values
| Value name    | Description |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| userNotebookType                        | The machine type to be used for user notebooks                                                                                                  |
| users                                   | The number of users which will be using this applications. This is used to determine how much resources will be allocated to the proxy and hub. |
| advanced.additionalAdmin                | Dataporten User ID who can also be admin of this instance in addition to user who is deploying this hub |
| advanced.jupyterLab.enabled             | Whether or not run notebooks in jupyter lab interface |
| advanced.debug                          | Whether or not to enable verbose logging.                                                                                                       |
| advanced.userImage                      | The Docker image to use when creating a new user notebook                                                                                       |
| advanced.killidlepods.enabled           | Whether or not idle notebooks should be killed. |
| advanced.killidlepods.timeout           | How long in seconds a notebook must be idle before killing it. |
| advanced.killidlepods.concurrency       | How many idle notebooks to at most kill in parallel. |
| advanced.notebook.spawnLimit            | How many notebooks that the hub at most can spawn. |
| advanced.sharedData.enabled             | Whether or not to share the persistent storage among the users of the hub |
| advanced.sharedData.readOnly            | Should the shared data be read only? |
| advanced.sharedData.subPath             | Allows you to mount a subfolder of the persistent storage. |
