# Builder
FROM docker:stable AS builder

RUN apk update
RUN apk add dos2unix shellcheck wget

WORKDIR /root

# Download Google Cloud SDK: https://cloud.google.com/sdk/docs/#linux
RUN wget -q --progress=bar:force:noscroll --show-progress https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-274.0.1-linux-x86_64.tar.gz -O google-cloud-sdk.tar.gz
RUN tar -xzf google-cloud-sdk.tar.gz

COPY entrypoint.sh entrypoint.sh
RUN dos2unix entrypoint.sh

# Application
FROM docker:stable

RUN apk update
RUN apk add python2

# Install Google Cloud SDK: https://cloud.google.com/sdk/docs/#linux
COPY --from=builder /root/google-cloud-sdk /root/google-cloud-sdk
RUN yes 'n' | /root/google-cloud-sdk/install.sh
ENV GCLOUD /root/google-cloud-sdk/bin/gcloud

COPY --from=builder /root/entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
