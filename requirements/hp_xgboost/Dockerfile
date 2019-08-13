FROM fastscore/engine:xgboost


WORKDIR /fastscore
COPY hp_xgboost.py3 hp_input.avsc hp_output.avsc rest.json /fastscore/models/hp_xgboost/
ENV MODEL /fastscore/models/hp_xgboost/hp_xgboost.py3
ENV SCHEMAS hp_input:/fastscore/models/hp_xgboost/hp_input.avsc;hp_output:/fastscore/models/hp_xgboost/hp_output.avsc
ENV STREAMS 0:/fastscore/models/hp_xgboost/rest.json;1:/fastscore/models/hp_xgboost/rest.json


ADD ./model_artifacts.tar.gz /fastscore/artifacts/


