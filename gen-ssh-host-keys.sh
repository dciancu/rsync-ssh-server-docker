#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR"

if [ ! -d data ]; then
    mkdir data
fi
chmod 700 data
if [ ! -d data/ssh ]; then
    mkdir data/ssh
fi
chmod 700 data/ssh

if [ ! -f data/ssh/ssh_host_ed25519_key ]; then
    ssh-keygen -q -t ed25519 -a 100 -f data/ssh/ssh_host_ed25519_key -N ''
fi
if [ ! -f data/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -q -t rsa -b 4096 -a 100 -f data/ssh/ssh_host_rsa_key -N ''
fi
