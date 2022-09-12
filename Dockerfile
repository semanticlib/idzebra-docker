# syntax=docker/dockerfile:experimental

FROM alpine:latest

ARG YAZ_VERSION=5.32.0
ARG IDZEBRA_VERSION=2.2.5

ENV BUILD_DIR=/tmp/build \
    REQ_BUILD="wget alpine-sdk bison libxslt-dev gnutls-dev icu-dev libgcrypt-dev libgpg-error-dev" \
    REQ_RUN="busybox libxslt gnutls icu libgcrypt libgpg-error" \
    USER=idzebra \
    YAZ_DOWNLOAD_URL=http://ftp.indexdata.dk/pub/yaz/yaz-$YAZ_VERSION.tar.gz \
    IDZEBRA_DOWNLOAD_URL=https://ftp.indexdata.com/pub/idzebra/idzebra-$IDZEBRA_VERSION.tar.gz \
    IDZEBRA_DIR=/opt/idzebra \
    CONF_FILE=/etc/idzebra/yazserver.xml

# Update and install dependencies
RUN apk --update upgrade && \
    apk add --no-cache $REQ_RUN $REQ_BUILD && \
# Create $USER
    addgroup -Sg 1000 $USER && \
    adduser -SG $USER -u 1000 -h /src $USER && \
# Create directories
    mkdir -p $BUILD_DIR $IDZEBRA_DIR && \
# Get and extract YAZ
    cd $BUILD_DIR && \
    echo "Downloading '$YAZ_DOWNLOAD_URL'" && \
    wget $YAZ_DOWNLOAD_URL && \
    tar xzf $(basename $YAZ_DOWNLOAD_URL) && \
# Get and extract ZEBRA
    cd $BUILD_DIR && \
    echo "Downloading '$IDZEBRA_DOWNLOAD_URL'" && \
    wget $IDZEBRA_DOWNLOAD_URL && \
    tar xzf $(basename $IDZEBRA_DOWNLOAD_URL) && \
# Configure and build YAZ
    cd /tmp/build/$(basename $YAZ_DOWNLOAD_URL .tar.gz) && \
    ./configure --with-iconv --with-xslt --with-xml2 --with-icu --with-gnutls --prefix=/usr/local && \
    make install && \
# Configure and build ZEBRA
    cd /tmp/build/$(basename $IDZEBRA_DOWNLOAD_URL .tar.gz) && \
    ./configure && \
    make install && \
# Copy default config
    cp -r /usr/local/share/idzebra-2.0-examples/marc21 $IDZEBRA_DIR && \
    cd $IDZEBRA_DIR/marc21 && \
    sed -i 's/\/usr\/share/\/usr\/local\/share/g' zebra.cfg && \
    sed -i 's/\/usr\/lib/\/usr\/local\/lib/g' zebra.cfg && \
    /usr/local/bin/zebraidx -c zebra.cfg init && \
    /usr/local/bin/zebraidx update sample-marc && \
# Cleanup
    rm -rf $BUILD_DIR && \
    apk del $REQ_BUILD


EXPOSE 9998

COPY yazserver.xml $CONF_FILE

RUN chown -R $USER:$USER $IDZEBRA_DIR

USER $USER

ENTRYPOINT /usr/local/bin/zebrasrv -f $CONF_FILE
