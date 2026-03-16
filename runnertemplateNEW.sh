#!/bin/bash
set -euo pipefail

SUDO=
CONTAINER_MGR=docker
CONTAINER_IMG=gitlab/gitlab-runner:latest
RUNNER_VOL=gitlab-runner-conjur-config
RUNNER_NAME=gitlab-runner-conjur
GITLAB_URL="https://gitlab.com/"
RUNNER_TOKEN="REPLACE_WITH_YOUR_RUNNER_TOKEN"

$SUDO $CONTAINER_MGR volume create "$RUNNER_VOL"

$SUDO $CONTAINER_MGR rm -f "$RUNNER_NAME" 2>/dev/null || true

$SUDO $CONTAINER_MGR run -d --name "$RUNNER_NAME" --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$RUNNER_VOL":/etc/gitlab-runner \
  "$CONTAINER_IMG"

$SUDO $CONTAINER_MGR run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$RUNNER_VOL":/etc/gitlab-runner \
  "$CONTAINER_IMG" register \
  --non-interactive \
  --url "$GITLAB_URL" \
  --token "$RUNNER_TOKEN" \
  --executor "docker" \
  --docker-image "alpine:latest"