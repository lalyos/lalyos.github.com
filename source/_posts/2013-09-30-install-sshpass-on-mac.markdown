---
layout: post
title: "Install sshpass on mac"
date: 2013-09-30 14:07
comments: true
categories: [mac, homebrew, ssh, install, sshpass, ansible]
---

I'm experimenting with [ansibe](http://www.ansibleworks.com/), an awesome IT orchestration engine. It deservse its own blog entry, but in short: **It's an alternative of puppet and chef, but its much easier to learn**, and dowsn't require any client side agent installation.

## passwordless ssh

Its higly recommended to use public key authentication, but sometimes you have to deal with passwords. Let's say a fresh virtual environment is always created with a default password.

When I tried to call ansible with **-k** password, meaning ask for password, i faced the following message:

```
to use the 'ssh' connection type with passwords, you must install the sshpass program
```

## installing sshpass

Installing sshpass on linux is as easy as calling *apt-get* or *yum*, whatever package manager its using. Unfortunately **homebrwe**, my favourite package manager for mac doesn't supports this package officially.

Actually it was created, but the team refused to take [it](https://github.com/mxcl/homebrew/pull/9577) as its a bad practice to put passwords into scripts.

However there is an unofficial brew package:

```
brew install https://raw.github.com/eugeneoden/homebrew/eca9de1/Library/Formula/sshpass.rb
```
