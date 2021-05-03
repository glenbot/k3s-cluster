#!/usr/bin/env bash
root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing longhorn"

if ! kubectl get ns "{{ (datasource "config").longhorn.namespace }}" &> /dev/null; then
    kubectl create ns "{{ (datasource "config").longhorn.namespace }}"
fi

# Install the helm chart
helm upgrade -i longhorn longhorn/longhorn --version "{{ (datasource "config").longhorn.chart_version }}" -n "{{ (datasource "config").longhorn.namespace }}"

if ! kubectl get ingressroute -n "{{ (datasource "config").longhorn.namespace }}" longhorn-frontend-external &> /dev/null; then
  kubectl apply -n "{{ (datasource "config").longhorn.namespace }}" -f "${root_dir}/longhorn-frontend-ingress.yaml"
fi

echo "Done."