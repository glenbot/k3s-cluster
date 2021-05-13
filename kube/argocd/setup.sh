#!/usr/bin/env bash
root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if ! kubectl get ns "{{ (datasource "config").argocd.namespace }}" &> /dev/null; then
    kubectl create ns "{{ (datasource "config").argocd.namespace }}"
fi

kubectl apply -n "{{ (datasource "config").argocd.namespace }}" -f "https://raw.githubusercontent.com/argoproj/argo-cd/{{ (datasource "config").argocd.version }}/manifests/install.yaml"

if ! kubectl get ingressroute -n "{{ (datasource "config").argocd.namespace }}" argocd-frontend-external &> /dev/null; then
  kubectl apply -n "{{ (datasource "config").argocd.namespace }}" -f "${root_dir}/argocd-frontend-ingress.yaml"
fi
