#!/bin/bash

VERSION=0.4.4

IMAGE=docker.io/orrisroot/cors-anywhere
docker build --pull --force-rm -t ${IMAGE}:latest .
IMAGE_ID=$(docker image ls orrisroot/cors-anywhere:latest -q)
docker image tag ${IMAGE_ID} ${IMAGE}:${VERSION}
docker image tag ${IMAGE_ID} ${IMAGE}:${VERSION}-$(date '+%Y%m%d')

#docker login
#docker image push --all-tags ${IMAGE}
