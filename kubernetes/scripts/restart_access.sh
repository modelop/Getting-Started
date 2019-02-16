#!/bin/bash -x

kubectl delete pod `kubectl get pods | awk '/access/ {print $1}'`
kubectl get pods 
