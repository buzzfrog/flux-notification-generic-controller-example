#!/bin/sh
set -o errexit

kind delete cluster
kind create cluster

flux install

kubectl apply -f deploy-notification-sink.yaml
kubectl apply -f deploy-curl.yaml
kubectl apply -f flux-gitrepository.yaml
kubectl apply -f flux-kustomization.yaml
kubectl apply -f flux-notification-provider.yaml
kubectl apply -f flux-notification-alert.yaml
