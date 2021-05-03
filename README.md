# K3S Cluster

Install and configure a K3S cluster with 1 master and X nodes with docker as container runtime and traefik disabled by default.

This will also install:

* Kubedb Community Edition - for databases of all kinds 
* Metal LB - for http/tcp load balancing
* Traefik v2 - for ingress with godaddy certifying Let's encrypt certs.

# Prerequisites

Run `./init.sh` to check if you have all the correct binaries installed.

Example output:

```shell
$ ./init.sh
Running system checks.
Checking for binaries.
Checking for helm --> ✔
Checking for kubectl --> ✔
Checking for gomplate --> ✔
Checking for ansible --> ✔
Checking versions.
Checking helm version --> ✔
Checking kubectl version --> ✔
```

**Pre-Install Ubuntu 20.04 LTS on all nodes**

OS can probably be any debian release. Must have `apt` package manager as scripts currently require it.

## Setup

You will need to create 3 files:

* `hosts` - for ansible hosts inventory
* `ansible-variables.yaml` - for variables to use on the cluster installation
* `kube-variables.yaml` - for variables to use on the helm chart installations

`hosts` - place this file in the ansible directory and name it `hosts`. See example contents below. Make sure and replace `XXX.XXX.XXX.XXX` with the correct IPs and you can also change the hostnames ie. `gb-master-0`

```ini
[k3s-master]
gb-master-0 ansible_host=XXX.XXX.XXX.XXX ansible_ssh_port=22
[k3s-worker]
gb-worker-0 ansible_host=XXX.XXX.XXX.XXX ansible_ssh_port=22
gb-worker-1 ansible_host=XXX.XXX.XXX.XXX ansible_ssh_port=22
gb-worker-2 ansible_host=XXX.XXX.XXX.XXX ansible_ssh_port=22
gb-worker-3 ansible_host=XXX.XXX.XXX.XXX ansible_ssh_port=22
gb-worker-4 ansible_host=XXX.XXX.XXX.XXX ansible_ssh_port=22
gb-worker-5 ansible_host=XXX.XXX.XXX.XXX ansible_ssh_port=22
gb-worker-6 ansible_host=XXX.XXX.XXX.XXX ansible_ssh_port=22
```

`ansible-variables.yaml` place this in the root directory. See example contents below:

```yaml
user: myosuser
downloads: /path/to/downloads/used/for/kube/config
```

`kube-variables.yaml` place this in the root directory. See example contents below:

```yaml
metallb:
  namespace: metallb-system
  version: v0.9.6
  address_pool: XXX.XXX.XXX.XXX-XXX.XXX.XXX.XXX
traefik:
  chart_version: 9.19.0
  namespace: traefik
  domain: my.domain.com
  dashboard_subdomain: traefik
  dns_challenge_type: godaddy
  godaddy_api_key: XXXX
  godaddy_api_secret: XXX
  staging_cert: false  # true if you want to test with staging certificates from let's encrypt
  load_balancer_ip: XXX.XXX.XXX.XXX # an ip address from the metallb address pool above
kubedb:
  # https://github.com/appscode/offline-license-server#offline-license-server
  # Must run command below first with your email to get a license token and
  # the apply it to credentials below.
  # curl -d "email=***" -X POST https://license-issuer.appscode.com/register
  kube_context: mycontexthere  # put your kube context here (kubectl config current-context)
  namespace: kubedb
  chart_version: v0.18.0
  chart_version_catalog: v2021.04.16
  # for a place to store the license file
  downloads: /path/to/store/downloads/to/for/example/the/kubedb/license/file
  license_creds:
    cluster_name: myclustername
    email: myemail
    token: mytoken # generated from contents above
```

# Provisioning

After running all steps above, next steps are:

* Step 1. `./setup-cluster.sh`
* Step 2. `./setup-kube-packages.sh`
