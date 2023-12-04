#!/usr/bin/env bash

set -xeuo pipefail

curl --silent --connect-timeout 1 standard.open-contracting.org:8255 || true
ssh ocds-docs@standard.open-contracting.org mkdir -p /home/ocds-docs/web/staging/"$PATH_PREFIX"
rsync -az --delete-after build/ ocds-docs@standard.open-contracting.org:web/staging/"$PATH_PREFIX""${GITHUB_REF##*/}"

ocdsindex sphinx build/ https://standard.open-contracting.org/staging/"$PATH_PREFIX""${GITHUB_REF##*/}"/ > documents.json
ocdsindex index https://standard.open-contracting.org:9200 documents.json
