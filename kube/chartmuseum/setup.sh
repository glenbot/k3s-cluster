#!/usr/bin/env bash
root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if ! kubectl get ns "{{ (datasource "config").chartmuseum.namespace }}" &> /dev/null; then
    kubectl create ns "{{ (datasource "config").chartmuseum.namespace }}"
fi

helm repo add chartmuseum https://chartmuseum.github.io/charts
helm repo update

helm upgrade --install chartmuseum chartmuseum/chartmuseum \
    -n "{{ (datasource "config").chartmuseum.namespace }}" \
    -f "${root_dir}/chartmuseum-values.yaml" \
    --version "{{ (datasource "config").chartmuseum.chart_version }}"

if ! kubectl get ingressroute -n "{{ (datasource "config").chartmuseum.namespace }}" chartmuseum-frontend-external &> /dev/null; then
  kubectl apply -n "{{ (datasource "config").chartmuseum.namespace }}" -f "${root_dir}/chartmuseum-frontend-ingress.yaml"
fi
