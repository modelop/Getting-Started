FROM fastscore/engine:1.10-ubuntu

RUN pip install gensim==3.8.0
RUN pip install nltk==3.4

RUN python3 -m nltk.downloader averaged_perceptron_tagger
