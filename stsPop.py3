import os
import requests
import json

try:
	os.system("rm library/streams/sts-input.json")
except:
	print ("error")
	
SAMLAssertion = "Adsfasdfdfdsfadfadsfadfasdfasdfsafd"

Stream = """{
 "Encoding": "JSON",
  "Transport": {
    "AssumeRoleWithSAML": {
              "RoleArn": "arn:aws::...",
              "SAMLAssertion": "%s",
    }
    "Type": "S3",
    "Bucket": "iris-data-bucket",
    "ObjectKey": "xgboost_iris_inputs.jsons",
    "Region": "us-east-2"
  }
}"""%SAMLAssertion

f = open("library/streams/sts-input.json", "w")
f.write(Stream)
f.close()

os.system("fastscore stream add sts-input library/streams/sts-input.json")


"""
data=requests.get(dashboardURL+"api/1/service/"+engine+"/1/job/input/0", verify=False)
scores.append(data.json())
"""
