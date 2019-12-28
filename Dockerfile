# Builder
FROM docker:stable AS builder

RUN apk update
RUN apk add dos2unix shellcheck

WORKDIR /root

COPY entrypoint.sh entrypoint.sh
RUN dos2unix entrypoint.sh

# Application
FROM docker:stable

COPY --from=builder /root/entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
