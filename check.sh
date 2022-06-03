#!/bin/bash

BASE_IMAGE="gcr.io/distroless/nodejs:16"
TARGET_IMAGE="docker.io/orrisroot/cors-anywhere:latest"

REQUIRED_COMMANDS=("skopeo" "jq" "basename")

for COMMAND in "${REQUIRED_COMMANDS[@]}"; do
    if ! command -v ${COMMAND} > /dev/null; then
        echo "Error: ${COMMAND} command is required." 1>&2
        exit 2
    fi
done

check_image () {
    local BASE_CONTAINER=$1
    local TARGET_CONTAINER=$2
    local BASE_JSON=$(skopeo inspect docker://${BASE_CONTAINER})
    [ $? -eq 0 ] || return $?
    local TARGET_JSON=$(skopeo inspect docker://${TARGET_CONTAINER})
    [ $? -eq 0 ] || return $?
    local BASE_LAYER_ID=$(echo ${BASE_JSON} | jq "(.Layers | reverse)[0]")
    local FOUND_LAYER_ID=$(echo ${TARGET_JSON} | jq ".Layers[] | select(. == ${BASE_LAYER_ID})")

    if [ "${BASE_LAYER_ID}" != "${FOUND_LAYER_ID}" ]; then
        echo "The base Docker image has been updated."
        echo "- ${BASE_CONTAINER}"
        echo "The inherited Docker image needs to be updated."
        echo "- ${TARGET_CONTAINER}"
        echo ""
        return 1
    fi

    return 0
}

check_image "${BASE_IMAGE}" "${TARGET_IMAGE}"
