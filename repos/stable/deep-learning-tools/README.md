# Deep learning tools
A collection of several commonly used deep learning tools, such as Tensorflow,
Pytorch, Keras, Theano and CNTK made available through a jupyter notebook. In addition there is [Tensorboard](https://www.tensorflow.org/programmers_guide/summaries_and_tensorboard) and [Visdom](https://github.com/facebookresearch/visdom) are available for visualization during training.

### Advanced
This application creates a Jupyter Notebook instance using the following Dockerfiles:
  - [quay.io/Uninett/deep-learning-tools](https://github.com/Uninett/helm-charts-dockerfiles/tree/f8b3a46/deep-learning-tools/Dockerfile)

#### Values
| Value name    | Description |
| ------------- | ----------------------------------------------------------------------------------------------------------- |
| advanced.githubToken        | If you need to access private Github repositories, you need to specify a Github access token. |
| advanced.env.jupyterLab     | Whether or not to use JupyterLab                                                              |
| advanced.env.sparkMasterUrl | The URL to use when attempting to connect to Spark from a Jupyter notebook.                   |
