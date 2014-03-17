---
layout: post
title: "install docker binary"
date: 2014-02-24 16:52
comments: true
categories: 
---

Docker can be installed as binary from `get.docker.io` as described in the docs: [Get the docker binary](http://docs.docker.io/en/latest/installation/binaries/#get-the-docker-binary)

## Linux

```
wget https://get.docker.io/builds/Linux/x86_64/docker-latest -O docker
chmod +x docker
```

## Mac

The mac binary installation is described in a different documentation page: [Docker OS X Client](http://docs.docker.io/en/latest/installation/mac/#docker-os-x-client)

```
curl -o docker https://get.docker.io/builds/Darwin/x86_64/docker-latest
chmod +x docker
```

<!-- more -->

## Install a Previous Version

Sometimes I need a specific docker client version as 0.8 server is not compatible with earlier version. By playing with the url, I figured that by changing `latest` to a specific version number i can download earlier releases:

```
# get 0.7.5
curl -O http://get.docker.io/builds/Darwin/x86_64/docker-0.7.5
chmod +x docker-0.7.5

# get 0.8.0
curl -O http://get.docker.io/builds/Darwin/x86_64/docker-0.8.0
chmod +x docker-0.8.0
```
