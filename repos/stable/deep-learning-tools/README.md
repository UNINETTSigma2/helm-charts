By installing this package, a Jupyter notebook with various pre-installed
deep-learning related tools will be created.
After installing, you will be able to access this notebook using your web browser.

This package includes a collection of several commonly used deep learning tools, such as Tensorflow,
Pytorch, Keras, Theano and CNTK made available through a jupyter notebook.
In addition there is [Tensorboard](https://www.tensorflow.org/programmers_guide/summaries_and_tensorboard) and [Visdom](https://github.com/facebookresearch/visdom) are available for visualization during training.


## Features

- A browser accessible and user customisable Jupyter notebook
- Various machine learning and visualization libraries
- Pre-configured GPU drivers
- Support for distributed computing using Apache Spark

------

## Advanced

This application creates a Jupyter Notebook instance using the following Dockerfiles:

- [uninettSigma2/deep-learning-tools2](https://github.com/UninettSigma2/helm-charts-dockerfiles/tree/641af6f/deep-learning-tools2/Dockerfile)

### Values

| Value name    | Description |
| ------------- | ----------------------------------------------------------------------------------------------------------- |
| advanced.githubToken        | If you need to access private Github repositories, you need to specify a Github access token. |
| advanced.env.jupyterLab     | Whether or not to use JupyterLab                                                              |
| advanced.env.sparkMasterUrl | The URL to use when attempting to connect to Spark from a Jupyter notebook.                   |
