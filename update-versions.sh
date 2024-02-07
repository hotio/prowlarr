#!/bin/bash
set -e
branch=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/prowlarr/prowlarr/pulls?state=open&base=develop" | jq -re 'sort_by(.updated_at) | .[] | select((.head.repo.full_name == "Prowlarr/Prowlarr") and (.head.ref | contains("dependabot") | not)) | .head.ref')
branch=$(tail -n 1 <<< "${branch}")
version=$(curl -fsSL "https://prowlarr.servarr.com/v1/update/${branch}/changes?os=linuxmusl&runtime=netcore&arch=x64" | jq -re .[0].version)
curl -fsSL "https://prowlarr.servarr.com/v1/update/${branch}/updatefile?version=${version}&os=linuxmusl&runtime=netcore&arch=x64" -o /dev/null || exit 0
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg branch "${branch}" \
    '.version = $version | .branch = $branch' <<< "${json}" | tee VERSION.json
