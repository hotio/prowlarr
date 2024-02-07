#!/bin/bash
set -e
sbranch="nightly"
version=$(curl -fsSL "https://prowlarr.servarr.com/v1/update/${sbranch}/changes?os=linuxmusl&runtime=netcore&arch=x64" | jq -re .[0].version)
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg sbranch "${sbranch}" \
    '.version = $version | .sbranch = $sbranch' <<< "${json}" | tee VERSION.json
