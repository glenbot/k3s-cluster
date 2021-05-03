#!/usr/bin/env bash

ansible-playbook --extra-vars @ansible-variables.yaml -i ansible/hosts ansible/cluster.yaml --ask-become-pass
