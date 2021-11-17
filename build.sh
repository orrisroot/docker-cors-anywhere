#!/bin/bash

IMAGE=orrisroot/cors-anywhere
REGISTORY=docker.io/${IMAGE}
VERSION=0.4.4

docker build --pull --force-rm -t ${IMAGE}:latest .
IMAGE_ID=$(docker image ls orrisroot/cors-anywhere:latest -q)
NODE_VERSION=$(docker run --rm -it ${IMAGE}:latest --version | sed -e "s/^v//" -e "s/\r$//")
docker image tag ${IMAGE_ID} ${IMAGE}:${VERSION}
docker image tag ${IMAGE_ID} ${IMAGE}:${VERSION}-${NODE_VERSION}

#docker login
echo Done! To push built images, run the following command.
echo docker image push --all-tags ${IMAGE}
