---
layout: post
title: "Access docker containers via internal ip"
date: 2013-10-06 09:34
comments: true
categories: [dokker,ssh,socks,proxy,pac, tunnel, internal]
---

Whenn you run a lot of containers inside of a docker host, you can get lost of the forwarded ports. Let's say you have 3 instances all exposing 3 ports: 22, 80 and 443. Docker will automatically assign 'random' port numbers like:

```
ID            ...  PORTS
656eb7831dda  ...  49162->22, 49163->80, 49164->443   
ff2141eb218d  ...  49159->22, 49160->80, 49161->443   
54b9dfd5400c  ...  49156->22, 49157->80, 49158->443   
```

Now its hard to remember all those ports, and is confusing that if you want to ssh into the first one, you use `ssh root@docker -p 49162` and in the browser you would use: `http://docker:49163`. 

There is an even bigger problem with random ports. Wehn your **http** server sometimes redirects you to **https**, you need the standard port numbers. The webserver running inside of a docker container, will redirect you to port **443** which will not be correct port (49164 in our case)

So it would be much natural for the docker instances to use their ip address, with *straight* port numbers. But those ip addresses are only valid inside of the docker host. How to do the magic?

## SSH is yor best friend

There is complete SOCKS proxy hidden indide of ssh. To get it alive you just have to toss a `-D 1099` parameter, and boom, it will listen on your localhost's 1099 port and act as a proxy. So here is a how you create an ssh based *tunnel* :

```
ssh -qTfN2 -D 1099 docker
```

For the curious the parameter meanings:

- q :- be very quite
- T :- Do not allocate a pseudo tty
- f :- move the ssh process to background
- N :- Do not execute remote command.
- 2 :- Forces ssh to try protocol version 2 only.

## docker internal IPs

How can you get the internal ip of a container? You can get all the dirty details by: `sudo docker inspect XXXXX`. For the moment the only interresting this is the IP addresses. So the oneliner is:

```
for i in $(sudo docker ps -q); do sudo docker inspect $i| grep IPA; done
```

it will create the following list:

```
        "IPAddress": "172.17.0.12",
        "IPAddress": "172.17.0.11",
        "IPAddress": "172.17.0.10",
```

## SOCKS proxy

Now all the programs which can use a SOCKS proxy can access the docker containers. For example let's poke the first containers webserver with `curl`

```
curl --proxy socks5h://localhost:1099  172.17.0.10
```

for a java process ypu can specify it by system properties: `-DsocksProxyHost=127.0.0.1 -DsocksProxyPort=1099`


## SOCKS proxy for the browser

You have probably already uses an http proxy in your browser. In that case **all trafic** goes throught the http proxy. For our usecase what we wan is:

- accessing docker containers via **SOCKS proxy**
- all other shoud be accessed **directly**

Luckily thus problem is already solved by the [Proxy auto-config](http://en.wikipedia.org/wiki/Proxy_auto-config) or shortly PAC. Its a JavaScript function which returns with the connection type: PROXY/SOCKS/DIRECT. See the sample below:


```
function FindProxyForURL(url, host) {
 
        // URLs within this network are accessed through
        // socks proxy provided by ssh -D
        if (isInNet(host, "172.17.0.0", "255.255.0.0"))
        {
                return "SOCKS 127.0.0.1:1099";
        }
 
        return "DIRECT";
}
```

## SSH doesn't need a SOCKS proxy

We use ssh to create a SOCKS proxy, which can be used by other programs java/browser/curl and so on. But ssh is clever enough that if there is no SOCKS proxy opened, it can create it on demand:


```
ssh -o ProxyCommand='ssh user@10.253.129.151 nc %h %p' user@targetsshserver.example.com
```

This tells ssh that instead of connecting directly to targetsshserver.example.com's port 22, use a **ProxyCommand** to create the connection.

In this case the command itself is an ssh: `ssh user@docker nc %h %p` which means start a **NetCat** (nc host port) via ssh.
