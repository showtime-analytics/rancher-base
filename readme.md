rancher-base
============

Alpine-base image with basic extra software installed. (bash s6 openssl openssh curl confd and optional selfsigne_ca)

To build

```
docker build -t <repo>/rancher-base:<version> .
```

To run:

```
docker run -it <repo>/rancher-base:<version> 
```

