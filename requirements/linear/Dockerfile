FROM fastscore/engine:1.9
ADD ./requirements.txt .
ADD ./close_prices.jsons .
RUN pip3 install --isolated -r requirements.txt
RUN echo sklearn >> /fastscore/lib/engine-1.9/priv/runners/python3/python.stdlib
