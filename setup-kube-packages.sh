#!/usr/bin/env bash
root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RUN_DIR="${root_dir}/.run"
DRY_RUN=0

function usage {
    echo "${0} <services>"
    echo "Available Services: kubedb, metallb, traefik, longhorn, argocd, chartmuseum, onepassword"
    echo "optional args: "
    echo "  -d Dry run. Will only render the templates to the .run folder"
    echo "Example: ${0}"
    exit 1
}

while getopts "dh" arg
do
  case $arg in
    d) DRY_RUN=1;;
    h) usage;;
    *) usage;;
  esac
done

services=("$@")
available_services=("kubedb" "metallb" "traefik" "longhorn" "argocd" "chartmuseum" "onepassword")

# Clean up previous run
if [[ -d "${RUN_DIR}" ]]; then
    rm -rf "${RUN_DIR}"
fi
mkdir -p "${RUN_DIR}"

if [[ "${DRY_RUN}" == "1" ]]; then
  echo "****** RUNNING IN DRY RUN MODE ******"
fi

for service in "${services[@]}"; do
  case "${available_services[@]}" in *"${service}"*)
    echo "Installing ${service}"
    mkdir -p "${RUN_DIR}/${service}"
    for f in $(ls -d ${root_dir}/kube/${service}/*); do
        gomplate -d config="${root_dir}/kube-variables.yaml" --file "${f}" --out "${RUN_DIR}/${service}/$(basename ${f})" &>/dev/null
    done
    chmod +x ${RUN_DIR}/${service}/setup.sh

    if [[ "${DRY_RUN}" == "0" ]]; then
        ${RUN_DIR}/${service}/setup.sh
    fi
    echo "Done."
    ;;
  esac
done

echo "Finished setting up base kube packages."
