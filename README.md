Idzebra Docker image
====================

# Introduction

This `Dockerfile` provides [Zebra](https://www.indexdata.com/resources/software/zebra/) 
and [YAZ](https://www.indexdata.com/resources/software/yaz/) on Alpine Linux as Docker image.

The default configuration requires [YAZ GFS](https://software.indexdata.com/yaz/doc/server.vhosts.html) file.

# Quickstart

## Building the image

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
git clone https://github.com/semanticlib/idzebra-docker.git
cd idzebra-docker
docker build .
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Building a tagged image

A tagged image can be used to reference it in another `Dockerfile` (for extension).

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
docker build -t idzebra:latest .
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Running

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
docker run -p 9998:9998 idzebra:latest
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

