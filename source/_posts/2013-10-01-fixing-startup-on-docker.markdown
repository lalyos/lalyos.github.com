---
layout: post
title: "fixing startup on docker"
date: 2013-10-01 15:31
comments: true
categories: [docker, startup, ubuntu]
---

When working in [docker](http://www.docker.io/) container, you need to start services differently. Let's say you want to start **mysql**. You have 3 choices: 
 
- `mysqld_safe &` which is a quick and dirty solution but its not idempotent.
- `/etc/init.d/mysql restart` its the *old school* way
- `service mysql start` that's the *new school* way

Normally you would prefer the 3. option `service mysql start` but it needs *upstart* running which is normally the **/sbin/init** process with the special **pid** of 1.

Unfortunately inside of a docker instance the special **1 pid** is rserved for the command started by docker. In most case its either **/bin/bash**, or **sshd**, ot whatever service you are running in the container.

when you try to start mysql with  then you will most probably face the following message:

```
 Failed to connect to socket /com/ubuntu/upstart: Connection refused
```

thats because upstart is not running, or phrasing differently: **1 pid** is not **/sbin/init**

## upstart workaround

There is a workaround for supressing this messages:

```
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl
```

Of course you stil can't use `service mysql start`, but at least you wont get those error messages.

## related issues / pull-reqs

I can see that the docker issues/pull requests are disscussing it. But im still not sure the proper way to go. But here are the references:

- [issue 223](https://github.com/dotcloud/docker/issues/223): the original **Run /sbin/init** issue
- [issue 1024](https://github.com/dotcloud/docker/issues/1024): the **Container cannot connect to Upstart** issue where i found the workaround
- [issue 1311](https://github.com/dotcloud/docker/issues/1311) : **Production-ready process monitoring**
- [pull-req 898](https://github.com/dotcloud/docker/pull/898): Inject dockerinit at /.dockerinit instead of overwriting /sbin/init
- [pull-req 1209](https://github.com/dotcloud/docker/pull/1209): Upstart improvements
- [pull-req 1883](https://github.com/dotcloud/docker/pull/1883):  /usr/sbin/policy-rc.d  is added since the vast majority of docker users are surprised when they apt-get install or apt-get upgrade and services fail to start and that sometimes makes the install fail


## update

I just read the docker integration into `supervisor`-s () is [planned](http://blog.docker.io/2013/08/websockets-dockerfile-upgrade-better-registry-support-expert-mode-and-more/#better_integration_with_process_supervisors) for the upcomming 0.7 version

> For docker to be fully usable in production, it needs to cleanly integrate with the host machine’s process supervisor of choice. Whether it’s sysV-init, upstart, systemd, runit or supervisord, we want to make sure docker plays nice with your existing system. This will be a major focus of the 0.7 release.



