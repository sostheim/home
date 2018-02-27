The current public [Docker Hub](https://hub.docker.com) image for this Dockerfile is available here: [gcc-dev-env](https://hub.docker.com/r/sostheim/gcc-dev-env/).  Use the standard pull command to begin using it as is.
```
$ docker pull sostheim/gcc-dev-env
```

To build the execution/debugging environment image:
```
$ docker build --rm --pull --tag gcc-dev-env:latest .
```

Optionally, tag and push the image to a registry (default Docker Hub).  Replacing all occurences of `sostheim`  with an appropriate account that you have access to.
```
$ docker tag gcc-dev-env:latest sostheim/gcc-dev-env
$ docker push sostheim/gcc-dev-env:latest
```

To run the container:
```
# To run build tools only, use:
$ docker run -v "$(pwd)":/usr/src/`basename $(pwd)` -it sostheim/gcc-dev-env

# To run gdb, use:
$ docker run --security-opt seccomp=unconfined -v "$(pwd)":/usr/src/`basename $(pwd)` -it sostheim/gcc-dev-env
```

Either way, this will drop you in to a [bash](https://www.gnu.org/software/bash/) shell in the running container with access to the tools defined in the Dockerfile.  The project located at `$(pwd)` is mounted at `/usr/src/...`.  From here you can begin compiling, running, debugging, etc...

