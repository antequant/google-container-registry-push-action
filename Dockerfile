# Builder
FROM docker:stable AS builder

RUN apk update
RUN apk add dos2unix shellcheck

WORKDIR /root

COPY run.sh run.sh
RUN dos2unix run.sh

# Application
FROM docker:stable

WORKDIR /root

COPY --from=builder /root/run.sh run.sh
ENTRYPOINT [ "./run.sh" ]
