#
# Dockerfile - devlopment environment
#
FROM gcc:7.3.0

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
            cmake \
            bison \
            flex \
            gdb \
            cppcheck \
            libpoco-dev \
            libboost-all-dev \
            libcppunit-dev \
            valgrind; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src

CMD ["/bin/bash"]

