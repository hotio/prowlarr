#!/bin/bash

version=$(curl -fsSL "https://prowlarr.servarr.com/v1/update/nightly/changes?os=linuxmusl&runtime=netcore&arch=x64" | jq -r .[0].version)
[[ -z ${version} ]] && exit 0
[[ ${version} == "null" ]] && exit 0
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'"' <<< "${version_json}" > VERSION.json
