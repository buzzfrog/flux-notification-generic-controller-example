#!/bin/sh
set -o errexit

kind create cluster --name flux-not-test

flux install

kubectl apply -f deploy-notification-sink.yaml
kubectl apply -f flux-gitrepository.yaml
kubectl apply -f flux-kustomization.yaml
kubectl apply -f flux-notification-provider.yaml
kubectl apply -f flux-notification-alert-info.yaml
kubectl apply -f flux-notification-alert-error.yaml
