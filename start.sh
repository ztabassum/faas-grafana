#!/bin/bash

if [ -z "$1"  ]; then
  echo "Must include your openfaas namespace"
  exit 1
fi

namespace="$1"

image_name="faas-grafana"
image_tag="v1"

minikube_docker_env=$(minikube docker-env 2>&1)

if ! [[ $? != 0 ]]; then
    echo "Error: Make sure to start minikube"
fi

eval $(minikube -p minikube docker-env)

docker build -t "$image_name:$image_tag" grafana/.

while ! docker image inspect "$image_name:$image_tag" &> /dev/null; do
  sleep 1
done

kubectl  -n "$namespace" delete pod grafana

kubectl -n "$namespace" run --image="$image_name:$image_tag" --port=3000 grafana 

while [[ $(kubectl -n "$namespace" get pod grafana -o=jsonpath='{.status.phase}') != "Running" ]]; do
  sleep 1
done

kubectl port-forward pod/grafana 3000:3000 -n "$namespace" 