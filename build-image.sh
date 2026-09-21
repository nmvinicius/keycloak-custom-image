#!/usr/bin/env sh
set -eu

tag="${1:-ghcr.io/${GITHUB_REPOSITORY_OWNER:-your-github-user}/keycloak-custom:26.7.4}"

docker build -t "$tag" .
echo "Imagem criada: $tag"