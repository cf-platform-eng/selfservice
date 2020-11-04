FROM ubuntu

RUN apt-get update && \
    apt-get install -y curl jq && \
    rm -rf /var/lib/apt/lists/*

COPY selfservice /usr/local/bin/selfservice

ENTRYPOINT [ "selfservice" ]

