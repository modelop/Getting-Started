#fastscore.schema.0: hp_input
#fastscore.schema.1: hp_output
#fastscore.recordsets.$all: true

import pandas as pd
import pickle
import numpy as np

import datetime as dt

def begin():
    global xgboost_model, train_encoded_columns
    xgboost_model = pickle.load(open("/fastscore/artifacts/xgboost_model.pickle", "rb"))
   
    train_encoded_columns = pickle.load(open("/fastscore/artifacts/train_encoded_columns.pickle", "rb"))

def action(data):

    missing_cols = set(train_encoded_columns) - set(data.columns)
    for c in missing_cols:
        data[c] = 0

    data = data[train_encoded_columns]

    log_predictions = xgboost_model.predict(data)
    predictions = np.expm1(log_predictions)

    predictions = pd.DataFrame(predictions.reshape(-1,1), columns=['predicted_price'])
    yield predictions
