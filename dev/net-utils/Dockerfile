#
# Dockerfile - network test/troubleshooting environment
#
FROM ubuntu:latest

RUN set -ex; \
    apt update; \
    apt install -y --no-install-recommends \
        curl \
        lsb-release \
        ethtool \
        bridge-utils \
        inetutils-ping \
        inetutils-traceroute \
        iperf3 \
        openssh-client \
        iproute2 \
        ifstat \
        iftop \
        tcpdump \
        nmap; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /

ENTRYPOINT /bin/bash
