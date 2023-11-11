#!/bin/bash

set -euo pipefail

VOLUME=${1:?'Volume name required as first argument'}

volume_switches="-v ${VOLUME}:/source/${VOLUME}"

set -x
docker run --rm \
	-v "$(pwd):/backup" \
	"${volume_switches}" \
	ryansch/dockup:latest restore
