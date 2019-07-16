#fastscore.action: unused
#fastscore.schema.0: three_strings
#fastscore.schema.1: double
#fastscore.recordsets.1: true
#fastscore.module-attached: tensorflow
#fastscore.module-attached: tensorflow_hub
#fastscore.module-attached: xgboost

from fastscore.io import Slot

import xgboost as xgb
import pickle
import tensorflow_hub as hub
import tensorflow as tf
import numpy as np
import pandas as pd
from math import floor

slot0 = Slot(0)  # We will read input data from Slot(0)
slot1 = Slot(1)  # and output predictions/scores to Slot(1)

#  input_data will be a Pandas DataFrame
input_data = slot0.read(format="pandas.standard")

input_data = input_data.iloc[:50] # remove the limit "50" to test model on all input data

#  We load version 2 of the elmo module hosted on TensorFlow Hub
elmo = hub.Module("https://tfhub.dev/google/elmo/2", trainable = False)

def elmo_vectors(x):
    """A function to compute ELMo embeddings"""
    embeddings = elmo(x.tolist(), signature="default", as_dict = True)["elmo"]
    with tf.Session() as sess:
        sess.run(tf.global_variables_initializer())
        sess.run(tf.tables_initializer())
        # return average of ELMo features
        return sess.run(tf.reduce_mean(embeddings,1))

# Next, we batch input_data
percent_samples = 1  # Set to 1 to score all of input dataset       

batch_size = 50  # batch_size may be changed depending on memory allocation

lint_input_data = []

for i in range(0, floor(percent_samples*input_data.shape[0]),batch_size):
    list_input_data += input_data[i:i+batch_size]

# Let us now extract ELMo embeddings
globals().update(locals())

elmo_vecs = [elmo_vectors(x['comment_text']) for x in list_input_data]

elmo_vecs = np.concatenate(elmo_vecs, axis = 0)

# To score the ELMo embeddings, we first load a saved XGBoost model
loaded_model = pickle.load(open("//shared_data/ELMo_nlp_xgboost.pickle","rb"))

# We may now produce predictions
predictions = loaded_model.predict(xgb.DMatrix(elmo_vecs))

out = pd.Series(predictions)

slot1.write(out)
