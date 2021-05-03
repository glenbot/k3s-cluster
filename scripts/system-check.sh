#!/usr/bin/env bash
_root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


source "${_root_dir}/utils.sh"

# Check for all the required things to be installed
HELM_INSTALLED=$(which helm)
KUBECTL_INSTALLED=$(which kubectl)
GOMPLATE_INSTALLED=$(which gomplate)
ANSIBLE_INSTALLED=$(which ansible)

echogreen "Checking for binaries."

echoyellow -n "Checking for helm --> "
if [[ "${HELM_INSTALLED}x" == "x"  ]]; then
   echored "✘"
   echored "Helm not installed. Please install helm by: "
   echored "OSX: brew install helm"
   echored "Linux: https://helm.sh/docs/intro/install/"
   echored "Linux (optional): use brew"
   exit 1
else
  echogreen "✔"
fi

echoyellow -n "Checking for kubectl --> "
if [[ "${KUBECTL_INSTALLED}x" == "x"  ]]; then
   echored "✘"
   echored "Kubectl not installed. Please install kubectl by: "
   echored "OSX: brew install kubernetes-cli"
   echored "Linux: https://kubernetes.io/docs/tasks/tools/install-kubectl/"
   echored "Linux (optional): use brew"
   exit 1
else
  echogreen "✔"
fi

echoyellow -n "Checking for gomplate --> "
if [[ "${GOMPLATE_INSTALLED}x" == "x"  ]]; then
   echored "✘"
   echored "Gomplate not installed. Please install gomplate by: "
   echored "OSX: brew install gomplate"
   echored "Linux: https://docs.gomplate.ca/installing/"
   exit 1
else
  echogreen "✔"
fi

echoyellow -n "Checking for ansible --> "
if [[ "${ANSIBLE_INSTALLED}x" == "x"  ]]; then
   echored "✘"
   echored "Ansible not installed. Please install gomplate by: "
   echored "OSX: brew install ansible"
   echored "Linux: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-specific-operating-systems"
   exit 1
else
  echogreen "✔"
fi

echogreen "Checking versions."

echoyellow -n "Checking helm version --> "
vergreater $(helm version --template "{{.Version}}" | cut -d'v' -f2) "3.0.0"
if [[ $? -gt 0 ]]; then
   echored "✘"
   echored "Helm version must be >=3.0.0"
   exit 1
else
  echogreen "✔"
fi

echoyellow -n "Checking kubectl version --> "
vergreater $(kubectl version --short --client | cut -d'v' -f2) "1.15.0"
if [[ $? -gt 0 ]]; then
   echored "✘"
   echored "Kubectl version must be >=1.15.0"
   exit 1
else
  echogreen "✔"
fi
