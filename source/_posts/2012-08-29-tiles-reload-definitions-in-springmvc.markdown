---
layout: post
title: "Reload  tiles definitions in SpringMVC"
date: 2012-08-29 13:00
comments: true
categories: [spring, springmvc, tiles, reload]
---

If you have a springMVC application, normally you want some layout templating framewrok
so you don't have to repeat header/menu/footer in each jsp. One of the most 
popular choice is [tiles](http://tiles.apache.org/). Spring roo generates mvc apps use them as well.

While developing you often want to create a new page, which needs a new tiles definition 
in one of the tiles definition xml (views.xml). But the application **needs a redeploy**
to se those changes.

## For impatiens

If you don't care about the explanation, here is the solution: add 2 line to your webmvc-config.xml

``` diff changes needed in webmvc-config.xml
 <bean class="org.springframework.web.servlet.view.tiles2.TilesConfigurer"
       id="tilesConfigurer" >
+  <property name="useMutableTilesContainer">true</property>
+  <property name="checkRefresh">true</property>
   <property name="definitions">
     <list>
       <value>/WEB-INF/layouts/layouts.xml</value>
```

If you do care about details read on ...

<!-- more -->

## Typical springMVC configuration

{% gist 3509545 webmvc_config.xml %}

Unfortunately this will create a BasicTilesContainer, which is unable to reload definitions. 

## Use a 'mutable' TilesContainer

You can replace BasicTilesContainer with CachingTilesContainer by configuring tiles to use a **mutable** container.


If you would use tiles directly, than the **org.apache.tiles.factory.TilesContainerFactory.MUTABLE** property should be changed to true.
see [original tiles docs](http://tiles.apache.org/config-reference.html#org.apache.tiles.factory.TilesContainerFactory.MUTABLE)

If you use spring mvc, than you have to set the **useMutableTilesContainer** of TilesConfigurer.
see original spring 3.1.0.RELEASE source [here](https://github.com/SpringSource/spring-framework/blob/ac107d0c2ae939c669ba086c2874d02790519b06/org.springframework.web.servlet/src/main/java/org/springframework/web/servlet/view/tiles2/TilesConfigurer.java#L403)

``` diff changes needed in webmvc-config.xml
 <bean class="org.springframework.web.servlet.view.tiles2.TilesConfigurer"
       id="tilesConfigurer" >
+  <property name="useMutableTilesContainer">true</property>
   <property name="definitions">
     <list>
       <value>/WEB-INF/layouts/layouts.xml</value>
```

This will cause Spring's TilesConfigurer to use a CachingTilesContainer instead of a  BasicTilesContainer

## Check for changed tiles definitions

If you want the TilesContainer to check for modifications in tiles definitions you can instruct spring's TilesConfigurer
by adding the **checkRefresh** property:

``` diff changes needed in webmvc-config.xml
 <bean class="org.springframework.web.servlet.view.tiles2.TilesConfigurer"
       id="tilesConfigurer" >
   <property name="useMutableTilesContainer">true</property>
+  <property name="checkRefresh">true</property>
   <property name="definitions">
     <list>
       <value>/WEB-INF/layouts/layouts.xml</value>
```

Under the hood, it will pass this parameter to tiles [CachingLocaleUrlDefinitionDAO](http://tiles.apache.org/framework/apidocs/org/apache/tiles/definition/dao/CachingLocaleUrlDefinitionDAO.html#setCheckRefresh(boolean)) 

