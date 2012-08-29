---
layout: post
title: "Starting tomcat in debug mode from maven"
date: 2012-07-10 11:00
comments: true
categories: [maven, tomcat, debug]
---

If you want to start tomcat from maven you just simply run:

```
mvn tomcat:run
```

if you want to run it in debug mode, in order to be able to remote debug it, set the **MAVEN_OPTS** to:

```
export MAVEN_OPTS="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=9000"
```

## Connect from Eclipse

To connect to this process from eclipse/sts open the debug/debug configurations dialog, and choose: ** Remote Java Application** (even if it can be misleading as its running on localhost)