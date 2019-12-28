# Builder
FROM ubuntu:latest AS builder

RUN apt-get update
RUN apt-get install -y dos2unix shellcheck

WORKDIR /root

COPY entrypoint.sh entrypoint.sh
RUN dos2unix entrypoint.sh

# Application
FROM ubuntu:latest

RUN apt-get update

# Install Google Cloud SDK: https://cloud.google.com/sdk/docs/#deb
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get install -y apt-transport-https ca-certificates gnupg curl

RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update
RUN apt-get install -y google-cloud-sdk docker

COPY --from=builder /root/entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
