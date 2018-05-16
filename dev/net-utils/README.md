The current public [Docker Hub](https://hub.docker.com) image for this Dockerfile is available here: [net-utils](https://hub.docker.com/r/sostheim/net-utils/).  Use the standard pull command to begin using it as is.
```
$ docker pull sostheim/net-utils
```

To build the image:
```
$ docker build --rm --pull --tag net-utils:latest .
```

Optionally, tag and push the image to a registry (default Docker Hub).  Replacing all occurences of `sostheim`  with an appropriate account that you have access to.
```
$ docker tag net-utils:latest sostheim/net-utils
$ docker push sostheim/net-utils:latest
```

To run the container:
```
# To run the net-utils, use:
$ docker run -it sostheim/net-utils
```

Either way, this will drop you in to a [bash](https://www.gnu.org/software/bash/) shell in the running container with access to the tools defined in the Dockerfile.  From here you can begin testing, troubleshooting, etc...

