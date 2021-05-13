#!/usr/bin/env bash
root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if ! kubectl get ns "{{ (datasource "config").onepassword.namespace }}" &> /dev/null; then
    kubectl create ns "{{ (datasource "config").onepassword.namespace }}"
fi

helm repo add 1password https://1password.github.io/connect-helm-charts/
helm repo update

helm upgrade --install connect 1password/connect \
    -n "{{ (datasource "config").onepassword.namespace }}" \
    --version "{{ (datasource "config").onepassword.chart_version }}" \
    --set-file "connect.credentials={{ (datasource "config").onepassword.credentials }}"
