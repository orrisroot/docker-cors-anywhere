#!/bin/bash

set -euo pipefail

IMAGE=orrisroot/cors-anywhere
DIR=$(cd "$(dirname "$0")" && pwd)
# Read the version from dependencies.cors-anywhere in package.json (updated by Renovate)
VERSION=$(sed -n 's/^[[:space:]]*"cors-anywhere":[[:space:]]*"\([^"]*\)".*/\1/p' "${DIR}/package.json")

if ! [[ "${VERSION}" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
    echo "Invalid cors-anywhere version in package.json: '${VERSION}'" 1>&2
    exit 1
fi

if ! docker build --force-rm -t "${IMAGE}:latest" "${DIR}"; then
    echo "Build error occured." 1>&2
    exit 1
fi
docker image tag "${IMAGE}:latest" "${IMAGE}:${VERSION}"

echo ""
echo "Done! Built ${IMAGE}:latest and ${IMAGE}:${VERSION}."
