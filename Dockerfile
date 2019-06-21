FROM fastscore/engine:ubuntu
WORKDIR /fastscore

RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools
RUN pip3 install --upgrade tensorflow
RUN pip3 install --upgrade tensorflow_hub
RUN pip3 install --upgrade xgboost

USER root
RUN echo "tensorflow"     >> /fastscore/lib/engine-1.9.1+build.859.refbb4afea/priv/runners/python3/python.stdlib
RUN echo "tensorflow_hub" >> /fastscore/lib/engine-1.9.1+build.859.refbb4afea/priv/runners/python3/python.stdlib
RUN echo "xgboost"        >> /fastscore/lib/engine-1.9.1+build.859.refbb4afea/priv/runners/python3/python.stdlib
