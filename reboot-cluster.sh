#!/usr/bin/env bash

ansible-playbook -i ansible/hosts ansible/cluster_reboot.yaml --ask-become-pass
