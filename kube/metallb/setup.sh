#!/usr/bin/env bash

if ! kubectl get ns "{{ (datasource "config").metallb.namespace }}" &> /dev/null; then
    kubectl create ns "{{ (datasource "config").metallb.namespace }}"
fi

if ! kubectl get deploy -n "{{ (datasource "config").metallb.namespace }}" controller &> /dev/null; then
    kubectl apply -n "{{ (datasource "config").metallb.namespace }}" -f "https://raw.githubusercontent.com/metallb/metallb/{{ (datasource "config").metallb.version }}/manifests/namespace.yaml"
    kubectl apply -n "{{ (datasource "config").metallb.namespace }}" -f "https://raw.githubusercontent.com/metallb/metallb/{{ (datasource "config").metallb.version }}/manifests/metallb.yaml"
fi

# On first install only
if ! kubectl get secret -n "{{ (datasource "config").metallb.namespace }}" memberlist &> /dev/null; then
    kubectl create secret generic -n {{ (datasource "config").metallb.namespace }} memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
fi
