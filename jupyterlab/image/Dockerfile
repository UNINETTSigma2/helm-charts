FROM jupyter/datascience-notebook
RUN pip install npm
RUN pip install jupyterlab
RUN jupyter serverextension enable --py jupyterlab

ENV NOTEBOOKS_CONFIG_DIR /opt/jupyter/config
COPY jupyter_notebook_config.py $NOTEBOOKS_CONFIG_DIR/

COPY start-notebook.sh /usr/local/bin/
EXPOSE 8888
CMD ["start-notebook.sh"]
