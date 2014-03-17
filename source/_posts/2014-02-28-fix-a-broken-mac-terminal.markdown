---
layout: post
title: "Fix a broken mac terminal"
date: 2014-02-28 14:32
comments: true
categories: [mac, osx, terminal]
---

Sometimes my `Terminal` gets broken by either displaying binary files, or sometimes caused by a broken ssh connection.

You can fix it by copy pasting the following line:

```
tput init
tput reset
reset

```
You might not see the charaters even after pasted to the terminal, but keep on press `ENTER`, and suddenly your terminal is back to normal.
