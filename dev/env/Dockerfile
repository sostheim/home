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
            libboost-all-dev \
            libcppunit-dev \
            valgrind; \
    rm -rf /var/lib/apt/lists/*

# replaces libpoco-dev (stable), from the packages list above, with master (latest)
# allow non-zero exit from make command as some warnings are typical
RUN set -x; \
    cd tmp; \
    git clone https://github.com/pocoproject/poco.git; \
    cd poco; \
    ./configure --static --shared --no-tests --no-samples --omit=Data/MySQL,Data/ODBC,SQL/ODBC,Zip; \
    make -j2 -s install; \
    ldconfig; \
    cd ..; \
    rm -rf poco

WORKDIR /usr/src
