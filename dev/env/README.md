To build the execution/debugging environment container:
```
$ docker build --rm --pull --tag gcc-dev-env:latest .
```

Optionally push the container to a registry (default docker hub):
```
$ docker tag gcc-dev-env:latest sostheim/gcc-dev-env
$ docker push sostheim/gcc-dev-env:latest
```

To run in the container:
```
# To run build tools only, use:
$ docker run -v "$(pwd)":/usr/src/`basename $(pwd)` -it sostheim/gcc-dev-env

# To run gdb, use:
$ docker run --security-opt seccomp=unconfined -v "$(pwd)":/usr/src/`basename $(pwd)` -it sostheim/gcc-dev-env
```