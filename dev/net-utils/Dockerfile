#
# Dockerfile - network test/troubleshooting environment
#
FROM ubuntu:latest

RUN set -ex; \
    apt update; \
    apt install -y --no-install-recommends \
        lsb-release \
        snapd \
        curl \
        ethtool \
        dnsutils \
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
