#!/usr/bin/env bash
#
# Created on Mon May 05 2025 13:55:27
# Author: Mukai (Tom Notch) Yu
# Email: mukaiy@andrew.cmu.edu
# Affiliation: Carnegie Mellon University, Robotics Institute
#
# Copyright Ⓒ 2025 Mukai (Tom Notch) Yu
#

set -euo pipefail

set -a
. "$(dirname "$0")"/variables.sh
set +a

singularity build \
	--fix-perms \
	--build-arg-file "$(dirname "$0")/../.env" \
	--warn-unused-build-args \
	"$(dirname "$0")/../${IMAGE_NAME}_${IMAGE_TAG}.sif" \
	"$(dirname "$0")/../singularity/default.def"
