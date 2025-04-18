FROM debian:12-slim

SHELL ["/usr/bin/env", "bash", "-c"]

ARG USER_UID
ARG USER_GID
ARG DEBIAN_FRONTEND='noninteractive'

WORKDIR /root

RUN --mount=target=/var/lib/apt/lists,type=cache --mount=target=/var/cache/apt,type=cache \
    set -euo pipefail \
    && apt-get update \
    && apt-get install -y apt-transport-https ca-certificates \
    && sed -i 's/http:/https:/g' /etc/apt/sources.list.d/debian.sources \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && apt-get --purge autoremove -y \
    && apt-get install -y openssh-server rsync python3 \
    && sed -Ei '/^(#| |\t)*HostKey( |\t).*/d' /etc/ssh/sshd_config \
    && sed -Ei 's/^(#| |\t)*Port( |\t).*/Port 2222/' /etc/ssh/sshd_config \
    && sed -Ei 's/^(#| |\t)*PasswordAuthentication( |\t).*/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -Ei 's/^(#| |\t)*PermitRootLogin( |\t).*/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -Ei 's/^(#| |\t)*AllowAgentForwarding( |\t).*/AllowAgentForwarding no/' /etc/ssh/sshd_config \
    && sed -Ei 's/^(#| |\t)*AllowTcpForwarding( |\t).*/AllowTcpForwarding no/' /etc/ssh/sshd_config \
    && sed -Ei 's/^(#| |\t)*X11Forwarding( |\t).*/X11Forwarding no/' /etc/ssh/sshd_config \
    && sed -Ei 's/^(#| |\t)*PermitTTY( |\t).*/PermitTTY no/' /etc/ssh/sshd_config \
    && sed -Ei 's/^(#| |\t)*Subsystem( |\t)sftp( |\t).*/Subsystem sftp \/bin\/false/' /etc/ssh/sshd_config \
    && echo >> /etc/ssh/sshd_config \
    && echo 'HostKey /ssh/ssh_host_rsa_key' >> /etc/ssh/sshd_config \
    && echo 'HostKey /ssh/ssh_host_ed25519_key' >> /etc/ssh/sshd_config \
    && echo 'AllowUsers rsync' >> /etc/ssh/sshd_config \
    && rm /etc/ssh/ssh_host_* \
    && addgroup --gid "$USER_GID" rsync \
    && adduser --uid "$USER_UID" --gid "$USER_GID" --gecos '' --shell /bin/bash --disabled-password --no-create-home rsync \
    && mkdir /home/rsync \
    && chown rsync:rsync /home/rsync \
    && chmod 700 /home/rsync

COPY entrypoint.sh /root/

ENTRYPOINT ["bash", "/root/entrypoint.sh"]
