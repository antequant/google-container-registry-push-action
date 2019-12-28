#!/bin/sh

set -e
set -o errexit

yes 'n' | $GCLOUD init
cat > gcp_token.json <<__EOF__
$INPUT_GCP_TOKEN
__EOF__

$GCLOUD auth activate-service-account "$INPUT_GCP_EMAIL" --key-file gcp_token.json
yes | $GCLOUD auth configure-docker

REPO_NAME=$(basename "$GITHUB_REPOSITORY")
IMAGE_NAME="${INPUT_IMAGE_NAME:-$REPO_NAME}"

REPO_OWNER=$(dirname "$GITHUB_REPOSITORY")
GCP_PROJECT="${INPUT_GCP_PROJECT:-$REPO_OWNER}"

IMAGE_ID="gcr.io/$GCP_PROJECT/$IMAGE_NAME"

INFERRED_IMAGE_TAG=$(basename "$GITHUB_REF")
if [ "$INFERRED_IMAGE_TAG" = "master" ]
then
    INFERRED_IMAGE_TAG=latest
fi

IMAGE_TAG="${INPUT_IMAGE_TAG:-$INFERRED_IMAGE_TAG}"

docker build -t "$IMAGE_ID:$IMAGE_TAG" .
docker push "$IMAGE_ID:$IMAGE_TAG"