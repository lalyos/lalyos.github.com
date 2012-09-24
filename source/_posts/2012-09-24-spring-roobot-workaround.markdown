---
layout: post
title: "Spring RooBot workaround"
date: 2012-09-24 09:07
comments: true
categories: spring-roo roo roobot
---

I'm doing all sorts of trainings inside [Epam](http://www.epam.com/), and one of them is Spring Roo. Roo is a rapid application development tool, you can create maven based SpringMVC applications which serves hibernate JPA entities backed by mysql It's not limited to this framework mixture, although this is one of the most popular. 

Spring Roo is modular, you can install new features with the **install addon** command. The actual list of addons is collected by a process called **RooBot**. For some reason RooBot is unable to di his work since late June. Some explanation can be found at the [ROO-3184 Jira Issue](https://jira.springsource.org/browse/ROO-3184).

When you try to install any addon, or even list them you get the folowing:
```
roo> addon list 
No add-ons known. Are you online? Try the 'download status' command
```

## For the impatient

when you see that, just simple type the following (using the symbolic name of your missing addon)

```
osgi obr url add --url http://spring-roo-repository.springsource.org/repository.xml

osgi obr deploy --bundleSymbolicName org.springframework.roo.addon.cloud.foundry
osgi obr deploy --bundleSymbolicName org.springframework.roo.addon.git
```
if you are interested in the whole story just read on ...

<!-- more -->

## Addon Requirement ##

Quote of the [Official docs](http://static.springsource.org/spring-roo/reference/html-single/index.html#usage-add-ons)

> Roo's add-on distribution system encourages individual add-on developers to host their add-on web site (we don't believe in a central model where we must host add-ons on our servers). The main requirement an add-on developer needs to fulfill is their add-ons must be in OSGi format and their web site must include an OSGi Bundle Repository (OBR) index file. ... An OBR file is usually named repository.xml and it is available over HTTP. If you're curious what these OBR files look like, you can view the Spring Roo OBR repository at http://spring-roo-repository.springsource.org/repository.xml.

There are 2 types of addons:

- official or base: They are part of Spring Roo's [source repo](https://github.com/SpringSource/spring-roo)
- community: They are created, and hosted by the community.

## Base Addons 

It sounds like they are part of the distribution, so you assume that when you download a binary distribution, you alread have **all** base addon installed. Almost ... i couldn't figure it out, probably the once which require 3. party dependencies are not included in the binary distro. For example 2 of them:

- Git addon 
- CloudFoundry addon

There were already some issues about it in jira: [ROO-3276](https://jira.springsource.org/browse/ROO-3276) and I need both for my trainings so I was serching for some solution, and found in the docs the following:

> Even if an add-on is not listed in RooBot, you can still install it. The "osgi obr url add" command can be used to add the add-on's OBR URL to your Roo installation. This command is typically followed by an "osgi obr start" command to download and start the add-on. Importantly, the additional security verifications performed by RooBot are skipped ...

So if you recall the first quote's last sentence, starting with If you're **curious** ...
I was definitely curious so tried the following **in roo shell**:
 
```
osgi obr url add --url http://spring-roo-repository.springsource.org/repository.xml

osgi obr deploy --bundleSymbolicName org.springframework.roo.addon.cloud.foundry
osgi obr deploy --bundleSymbolicName org.springframework.roo.addon.git
```

## Community Addons 

Because they are registered only with RooBot, there is no easy workaround to get a list of them. Although as the official Roo doc's [Publishing to RooBot](http://static.springsource.org/spring-roo/reference/html-single/index.html#d4e3384) section suggests, you have to put your code to [Google Code](http://code.google.com/), and also there should be an osgi compliant **repository.xml** describint the specific addon and its dependencies. 

So theoretically one could serach for Spring Roo Addons on Google Code, collect all repository.xml, merge it one, and there you go, you replaced RooBot. By the way I'm trying to achieve it, stay tuned ...

## Missing Database Driver Wrappers

I saw also some other addon specific jira issues: [ROO-3191](https://jira.springsource.org/browse/ROO-3191) relating to database driver wrappers. They can use a similar workaround:

```
osgi obr url add --url http://spring-roo-repository.springsource.org/repository.xml
osgi obr deploy --bundleSymbolicName org.springframework.roo.wrapping.mysql-connector-java
osgi obr deploy --bundleSymbolicName org.springframework.roo.wrapping.h2
```
