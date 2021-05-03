#!/usr/bin/env bash
root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "${root_dir}/scripts/utils.sh"

echocyan "Running system checks."
source "${root_dir}/scripts/system-check.sh"
