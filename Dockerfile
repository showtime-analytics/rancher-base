FROM docker.io/alpine:3.2
MAINTAINER Raul Sanchez <rawmind@gmail.com>

# Install basic packages
RUN apk add --update bash openssl openssh curl && rm -rf /var/cacke/apk/* \
  && mkdir -p /opt/s6; \
wget https://github.com/just-containers/skaware/releases/download/v1.16.1/s6-2.2.2.0-linux-amd64-bin.tar.gz; \
tar -xvzf s6-2.2.2.0-linux-amd64-bin.tar.gz --directory /opt/s6; \
chmod -R 755 /opt/s6/usr/bin; \
mv /opt/s6/usr/bin/* /usr/bin; \
rm s6-2.2.2.0-linux-amd64-bin.tar.gz; \
rm -rf /opt/s6

# Install compile and install confd
ENV CONFD_VERSION=v0.11.0 GOMAXPROCS=2 \
    GOROOT=/usr/lib/go \
    GOPATH=/opt/src \
    GOBIN=/gopath/bin 

RUN apk add --update go git gcc musl-dev \
  && mkdir /opt/src; cd /opt/src \
  && git clone -b "$CONFD_VERSION" https://github.com/kelseyhightower/confd.git \
  && cd $GOPATH/confd/src/github.com/kelseyhightower/confd \
  && GOPATH=$GOPATH/confd/vendor:$GOPATH/confd CGO_ENABLED=0 go build -v -installsuffix cgo -ldflags '-extld ld -extldflags -static' -a -x . \
  && mv ./confd /usr/bin/ \
  && chmod +x /usr/bin/confd \
  && apk del go git gcc musl-dev \
  && rm -rf /var/cache/apk/* /opt/src \
  && mkdir -p /etc/confd/templates /etc/confd/conf.d

# Install selfsigned ca (optional)
#COPY <ca.crt> /etc/ssl/certs/<ca.pem>
#RUN cat /etc/ssl/certs/<ca.pem> >> /etc/ssl/certs/ca-certificates.crt && \
   #cd /etc/ssl/certs/ && \
   #ln -s <ca.pem> `openssl x509 -hash -noout -in <ca.pem>`.0
