---
layout: post
title: "debug ansible"
date: 2013-10-01 16:51
comments: true
categories: [ansible, debug]
---
If you reaaly want to see the ctual scripts ansible is running use the  `ANSIBLE_KEEP_REMOTE_FILES=1` to prevent ansible from deleting remote files.

<!-- more -->

## tl;dr

[Ansible](http://www.ansibleworks.com/) is the new kid in the *Configuration Management* / *Application Deployment* / *Continuous Delivery* field. Its much easier to learn than puppet/chef and it using **yaml** for describing playbooks.

Sometimes yo run into trouble when using ansible and want to get more detailed output for debugging the issue. Of course there is the `-v` option which can be even more verbose with `-vvv`.

## How ansible works

Ansible is well known for its unique feature of: **no agent needed**. Actually it does need something on the orchestrated node, namely pytho. But its true that in most modern *nix its already provided.

So How does ansible works behinde the sceenes: 

- you desribe your **playbook** in a YAML file
- ansible generates a python script
- copies it to the target node via ssh
- runs the python script
- collects the output/return codes
- deletes all the temporary scriptes/files from the remote host.

If you want to avoid the last step you can use the mentioned environment variable as:

```
ANSIBLE_KEEP_REMOTE_FILES=1  ansible -vvvv host -m shell -a 'hstname'
```
