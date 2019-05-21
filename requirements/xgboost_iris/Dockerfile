FROM fastscore/engine:explicit-models
ADD ./requirements.txt .

RUN pip3 install --isolated --user -r requirements.txt
USER root
RUN apt-get install cmake -y
RUN git clone --recursive https://github.com/dmlc/xgboost && \
	cd /fastscore/xgboost && \
	mkdir build && \
	cd /fastscore/xgboost/build && \
	cmake .. && \
	make -j4 && \
	cd /fastscore/xgboost/python-package &&\
	python3 setup.py install
USER 1000
