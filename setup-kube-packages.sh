#!/usr/bin/env bash
root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RUN_DIR="${root_dir}/.run"
DRY_RUN=0

function usage {
    echo "${0}"
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

# Clean up previous run
if [[ -d "${RUN_DIR}" ]]; then
    rm -rf "${RUN_DIR}"
fi
mkdir -p "${RUN_DIR}"

if [[ "${DRY_RUN}" == "1" ]]; then
  echo "****** RUNNING IN DRY RUN MODE ******"
fi

# Setup metallb
mkdir "${RUN_DIR}/metallb"
for f in $(ls -d ${root_dir}/kube/metallb/*); do
    gomplate -d config="${root_dir}/kube-variables.yaml" --file "${f}" --out "${RUN_DIR}/metallb/$(basename ${f})" &>/dev/null
done
chmod +x ${RUN_DIR}/metallb/setup.sh

if [[ "${DRY_RUN}" == "0" ]]; then
    ${RUN_DIR}/metallb/setup.sh
fi

# Setup traefik
mkdir "${RUN_DIR}/traefik"
for f in $(ls -d ${root_dir}/kube/traefik/*); do
    gomplate -d config="${root_dir}/kube-variables.yaml" --file "${f}" --out "${RUN_DIR}/traefik/$(basename ${f})" &>/dev/null
done
chmod +x ${RUN_DIR}/traefik/setup.sh

if [[ "${DRY_RUN}" == "0" ]]; then
    ${RUN_DIR}/traefik/setup.sh
fi

# Setup kubedb
mkdir "${RUN_DIR}/kubedb"
for f in $(ls -d ${root_dir}/kube/kubedb/*); do
    gomplate -d config="${root_dir}/kube-variables.yaml" --file "${f}" --out "${RUN_DIR}/kubedb/$(basename ${f})" &>/dev/null
done
chmod +x ${RUN_DIR}/kubedb/setup.sh

if [[ "${DRY_RUN}" == "0" ]]; then
    ${RUN_DIR}/kubedb/setup.sh
fi

# Setup longhorn
mkdir "${RUN_DIR}/longhorn"
for f in $(ls -d ${root_dir}/kube/longhorn/*); do
    gomplate -d config="${root_dir}/kube-variables.yaml" --file "${f}" --out "${RUN_DIR}/longhorn/$(basename ${f})" &>/dev/null
done
chmod +x ${RUN_DIR}/longhorn/setup.sh

if [[ "${DRY_RUN}" == "0" ]]; then
    ${RUN_DIR}/longhorn/setup.sh
fi

echo "Done."
