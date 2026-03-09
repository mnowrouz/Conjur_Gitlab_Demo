#!/bin/bash
#============ Variables ===============
# Is sudo required to run docker/podman - leave empty if no need
SUDO=sudo
# Using docker/podman
CONTAINER_MGR=docker
# Docker image URL
CONTAINER_IMG=gitlab/gitlab-runner:latest
# GitLab Host
#GITLAB_HOST=$(hostname -f)
# GitLab port
#GITLAB_PORT=
#============ Deploying GitLab Runner ===============
$SUDO $CONTAINER_MGR volume create gitlab-runner-conjur-config
$SUDO $CONTAINER_MGR run -d --name gitlab-runner-conjur --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v gitlab-runner-conjur-config:/etc/gitlab-runner \
    "$CONTAINER_IMG"

# Registering GitLab runner (no additional arguments)
$SUDO $CONTAINER_MGR run --rm -it -v gitlab-runner-conjur-config:/etc/gitlab-runner \
    "$CONTAINER_IMG" register -u https://gitlab.com/ --token glrt-t3_n7ej1KXzBVcKPcQv_pFR
	
	#
