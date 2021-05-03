#!/usr/bin/env bash
root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing Traefik"

{{ if eq (datasource "config").traefik.dns_challenge_type "godaddy" }}
if ! kubectl get secret -n "{{ (datasource "config").traefik.namespace }}" godaddy-dns &> /dev/null; then
kubectl create secret generic -n traefik \
  godaddy-dns \
  --from-literal=key={{ (datasource "config").traefik.godaddy_api_key }} \
  --from-literal=secret={{ (datasource "config").traefik.godaddy_api_secret }}
fi
{{ end }}

# Install the helm chart
helm upgrade -i traefik traefik/traefik --version "{{ (datasource "config").traefik.chart_version }}" -n "{{ (datasource "config").traefik.namespace }}" -f "${root_dir}/traefik-values.yaml"

if ! kubectl get ingressroute -n "{{ (datasource "config").traefik.namespace }}" traefik-dashboard-external &> /dev/null; then
  kubectl apply -n "{{ (datasource "config").traefik.namespace }}" -f "${root_dir}/traefik-dashboard-ingress.yaml"
fi

echo "Done."