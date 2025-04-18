#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR"

if [ ! -f /ssh/key.pub ]; then
    echo 'ERROR: Refusing to start without ssh key.pub'
    exit 1
fi

chmod 700 /home/rsync/.ssh
echo 'command="rrsync /backup",restrict' "$(tr -d '\n' < /ssh/key.pub)" > /home/rsync/.ssh/authorized_keys
chmod 600 /home/rsync/.ssh/authorized_keys
chown -R rsync:rsync /home/rsync/.ssh

chmod 700 /backup
chown rsync:rsync /backup

mkdir /run/sshd
chmod 700 /run/sshd

/usr/sbin/sshd -D -e
