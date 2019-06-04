FROM fastscore/engine:dev

WORKDIR /fastscore
COPY fasttext.py3 double.avsc string.avsc rest.json /fastscore/models/fasttext/
ENV MODEL /fastscore/models/fasttext/fasttext.py3
ENV SCHEMAS input:/fastscore/models/fasttext/string.avsc;output:/fastscore/models/fasttext/double.avsc
ENV STREAMS 0:/fastscore/models/fasttext/rest.json;1:/fastscore/models/fasttext/rest.json

#ENV MODEL /assets/fasttext.py3
#ENV SCHEMAS string:/assets/string.avsc;double:/assets/double.avsc
#ENV STREAMS 0:/assets/rest.json;1:/assets/rest.json


#WORKDIR /fastscore

ADD ./my_attachment_small.tar.gz /fastscore/artifacts/
ADD ./my_lib.tar.gz /fastscore/
