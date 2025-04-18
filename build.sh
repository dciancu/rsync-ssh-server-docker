#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR"

image_name="${DOCKER_IMAGE:-dciancu/rsync-ssh-server}"
image_arch="${BUILD_ARCH:-$(arch | tr -d '\n')}"

if [[ -n "${CIRCLE_BRANCH+x}" ]] && [[ "$CIRCLE_BRANCH" == 'test' ]]; then
    image_tag="${image_name}:test-${image_arch}"
else
    if [[ -n "${CIRCLE_BRANCH+x}" ]] && [[ "$CIRCLE_BRANCH" == 'build' ]]; then
        docker images | grep "$image_name" | tr -s ' ' | cut -d ' ' -f 2 \
            | xargs -I {} docker rmi -f "${image_name}:{}" || true
        docker buildx prune -f
    fi
    image_tag="${image_name}:latest-${image_arch}"
fi

docker build -t "$image_tag" --pull --build-arg "UID=${UID:-50000}" --build-arg "GID=${GID:-50000}" .

if [[ -n "${CIRCLE_BRANCH+x}" ]]; then
    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USERNAME" --password-stdin
    docker push "$image_tag"
fi
