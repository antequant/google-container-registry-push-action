#!/bin/sh

set -e
set -o errexit

echo "$1" | docker login docker.pkg.github.com -u "$GITHUB_ACTOR" --password-stdin

IMAGE_NAME=$(basename "$GITHUB_REPOSITORY")
IMAGE_ID="docker.pkg.github.com/$GITHUB_REPOSITORY/$IMAGE_NAME"
VERSION=$(basename "$GITHUB_REF")

if [ "$VERSION" == "master" ]
then
    VERSION=latest
fi

docker tag image "$IMAGE_ID:$VERSION"
docker push "$IMAGE_ID:$VERSION"