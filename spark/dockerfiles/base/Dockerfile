FROM debian:stretch
MAINTAINER Gurvinder Singh <gurvinder.singh@uninett.no>

# Install the dependecies
RUN apt update && apt upgrade -y && apt -y --no-install-recommends install \
    openjdk-8-jre wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Fetch Spark
ENV APACHE_SPARK_VERSION "2.2.0"
 RUN cd /tmp && \
     wget -q http://www-eu.apache.org/dist/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop2.6.tgz && \
     echo "28c8778c70fbcde32c6dcf85d0431b30 spark-${APACHE_SPARK_VERSION}-bin-hadoop2.6.tgz" | md5sum -c - && \
     tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop2.6.tgz -C /usr/local && \
     rm spark-${APACHE_SPARK_VERSION}-bin-hadoop2.6.tgz

# Install spark and setup corresponding ENV variables
RUN cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop2.6 spark
ENV SPARK_HOME /usr/local/spark
ENV R_LIBS_USER $SPARK_HOME/R/lib
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip
ENV PATH $SPARK_HOME/bin:$PATH

# Spark logging properties
COPY log4j.properties $SPARK_HOME/conf/log4j.properties
COPY spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf

# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.13.2/tini && \
    echo "790c9eb6e8a382fdcb1d451f77328f1fac122268fa6f735d2a9f1b1670ad74e3 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# Fix JAVA Truststore issue
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

ENTRYPOINT ["tini", "--"]
