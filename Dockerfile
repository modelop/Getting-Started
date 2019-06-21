FROM fastscore/engine:ubuntu
WORKDIR /fastscore

RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools
RUN pip3 install --upgrade tensorflow
RUN pip3 install --upgrade tensorflow_hub
RUN pip3 install --upgrade xgboost

USER root
RUN echo "tensorflow"     >> /fastscore/lib/`ls /fastscore/lib | grep engine`/priv/runners/python3/python.stdlib
RUN echo "tensorflow_hub" >> /fastscore/lib/`ls /fastscore/lib | grep engine`/priv/runners/python3/python.stdlib
RUN echo "xgboost"        >> /fastscore/lib/`ls /fastscore/lib | grep engine`/priv/runners/python3/python.stdlib
