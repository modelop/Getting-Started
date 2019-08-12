FROM fastscore/engine:dev-ubuntu
WORKDIR /fastscore
RUN pip3 install influxdb
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools
RUN pip3 install --upgrade xgboost

USER root
RUN echo "xgboost"        >> /fastscore/lib/`ls /fastscore/lib | grep engine`/priv/runners/python3/python.stdlib
