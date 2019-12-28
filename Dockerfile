# Builder
FROM ubuntu:latest AS builder

RUN apt-get update
RUN apt-get install -y dos2unix shellcheck wget

WORKDIR /root

# Prepare for installing Google Cloud SDK: https://cloud.google.com/sdk/docs/#deb
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN wget -q --progress=bar:force:noscroll --show-progress https://packages.cloud.google.com/apt/doc/apt-key.gpg

COPY entrypoint.sh entrypoint.sh
RUN dos2unix entrypoint.sh

# Application
FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y docker

# Install Google Cloud SDK: https://cloud.google.com/sdk/docs/#deb
COPY --from=builder /etc/apt/sources.list.d/google-cloud-sdk.list /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get install -y apt-transport-https ca-certificates gnupg

COPY --from=builder /root/apt-key.gpg /root/apt-key.gpg
RUN apt-key --keyring /usr/share/keyrings/cloud.google.gpg add /root/apt-key.gpg

RUN apt-get update
RUN apt-get install -y google-cloud-sdk

COPY --from=builder /root/entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
