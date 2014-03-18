---
layout: post
title: "Oracle JDK 7 on CentOS"
date: 2014-03-18 21:36
comments: true
categories:
  - centos
  - java
  - devops
---

When it comes to which java to use, Hadoop is a bit picky. It prefers
the Oracle jdk. See the [list of apache tested JDKs](http://wiki.apache.org/hadoop/HadoopJavaVersions).

Lately all the google references which use `wget` or `curl` are broken.

## Silent install

For the impatient here is the `one-liner`.

```bash
curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm' \
-H 'Cookie: oraclelicense=accept-securebackup-cookie'
rpm -i jdk-7u51-linux-x64.rpm
```
or if you really want it in one single line

```bash
curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie' && rpm -i jdk-7u51-linux-x64.rpm
```

## tl;dr

What I did was:
- opened Chrome **Developer Toolbar**
- went to the official oracle [download page](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html)
- clicked *Accept License Agreement*
- clicked on **jdk-7u51-linux-x64.rpm**
- as the download has started, I switched to the **Network** tab of the Developer Toolbar, and right-clicked on the rpm, and choos **Copy as cURL**

Voila! Of cours it was a huge line, but it can be trimmed down to just one singe required cookie: `oraclelicense=accept-securebackup-cookie`

Meanwhile it appeared on [stackowerflow](http://stackoverflow.com/questions/10268583/how-to-automate-download-and-instalation-of-java-jdk-on-linux) with a fatty +50 reputation bounty.
