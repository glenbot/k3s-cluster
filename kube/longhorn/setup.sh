#!/usr/bin/env bash
echo "Installing longhorn"

if ! kubectl get ns "{{ (datasource "config").longhorn.namespace }}" &> /dev/null; then
    kubectl create ns "{{ (datasource "config").longhorn.namespace }}"
fi

# Install the helm chart
helm upgrade -i longhorn longhorn/longhorn --version "{{ (datasource "config").longhorn.chart_version }}" -n "{{ (datasource "config").longhorn.namespace }}"

echo "Done."