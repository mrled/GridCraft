#!/bin/sh
set -eu

# Get the current commit hash
commit=$(git rev-parse HEAD)

# Check for an exact tag starting with v
tag=$(git tag --points-at "$commit" | grep -E '^v[0-9]' | head -n1)
if [ -n "$tag" ]; then
  echo "$tag"
else
  git rev-parse --short "$commit"
fi