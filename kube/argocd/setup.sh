#!/usr/bin/env bash
root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if ! kubectl get ns "{{ (datasource "config").argocd.namespace }}" &> /dev/null; then
    kubectl create ns "{{ (datasource "config").argocd.namespace }}"
fi

# Install argocd from url
kubectl apply -n "{{ (datasource "config").argocd.namespace }}" -f "https://raw.githubusercontent.com/argoproj/argo-cd/{{ (datasource "config").argocd.version }}/manifests/install.yaml"

# Patch API server deloyment for ingress
kubectl patch deploy argocd-server -n argocd -p '{"spec": {"template": {"spec": {"containers": [{"name": "argocd-server", "command": ["argocd-server", "--insecure", "--staticassets", "/shared/app"]}]}}}}'

if ! kubectl get ingressroute -n "{{ (datasource "config").argocd.namespace }}" argocd-frontend-external &> /dev/null; then
  kubectl apply -n "{{ (datasource "config").argocd.namespace }}" -f "${root_dir}/argocd-frontend-ingress.yaml"
fi
