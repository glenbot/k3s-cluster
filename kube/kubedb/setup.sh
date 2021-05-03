#!/usr/bin/env bash

echo "Installing Kubedb"

if ! kubectl get ns "{{ (datasource "config").kubedb.namespace }}" &> /dev/null; then
    kubectl create ns "{{ (datasource "config").kubedb.namespace }}"
fi

if [[ ! -f "{{ (datasource "config").kubedb.downloads }}/kubedb-licence.json" ]]; then
  echo "Generating license file for KUBEDB"
  k8s_context=$(kubectl config current-context)

  if [[ ! "{{ (datasource "config").kubedb.kube_context }}" =~ "${k8s_context}" ]]; then
    echo "It doesn't look like you are in the right cluster to generate kubedb license files"
    exit 1
  fi

  cluster_id=$(kubectl get ns kube-system -o=jsonpath='{.metadata.uid}')
  curl -X POST \
    -d "name={{ (datasource "config").kubedb.license_creds.cluster_name }}&email={{ (datasource "config").kubedb.license_creds.email }}&product=kubedb-community&cluster=${cluster_id}&tos=true&token={{ (datasource "config").kubedb.license_creds.token }}" \
    https://license-issuer.appscode.com/issue-license > "{{ (datasource "config").kubedb.downloads }}/kubedb-licence.json"
fi

helm upgrade kubedb-community appscode/kubedb-community \
    --install \
    --version "{{ (datasource "config").kubedb.chart_version }}" \
    --namespace "{{ (datasource "config").kubedb.namespace }}" \
    --set-file license="{{ (datasource "config").kubedb.downloads }}/kubedb-licence.json"

echo "Waiting on CRDs for kubedb"
sleep 20
kubectl get crds -l app.kubernetes.io/name=kubedb

helm upgrade kubedb-catalog appscode/kubedb-catalog \
    --install \
    --version "{{ (datasource "config").kubedb.chart_version_catalog }}" \
    --namespace "{{ (datasource "config").kubedb.namespace }}"

echo "Done."
