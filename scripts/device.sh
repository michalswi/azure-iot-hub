#!/usr/bin/env bash

set -e


create() {
    # portal / IoT Hub / Devices
    az iot hub device-identity create --device-id "$IOT_HUB_DEVICE_NAME" --edge-enabled false --hub-name "$IOT_HUB_NAME" --output none
    # portal / IoT Hub / IoT Edge
    # az iot hub device-identity create --device-id "$IOT_HUB_DEVICE_NAME" --edge-enabled --hub-name "$IOT_HUB_NAME" --output none
    read
}

delete() {
    az iot hub device-identity delete --device-id "$IOT_HUB_DEVICE_NAME" --hub-name "$IOT_HUB_NAME"
}

if declare -f "$1" >/dev/null; then
    "$@"
else
    echo "'$1' is not a known function name" >&2
    exit 1
fi
