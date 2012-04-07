---
title: DNS for internal service resolution and configuration
layout: post
category: blog
tags: [architecture, dns, spotify]
author: Aki Saarinen
published: true
---

[Ricardo Vice Santos](https://twitter.com/#!/ricardovice) gave an interesting
presentation about the [Spotify](http://www.spotify.com/) architecture
yesterday at [Reaktor Dev Day](http://reaktordevday.fi/).

What struck me as a clever yet rarely used idea was his description of their
usage of DNS for internal service resolution and configuration in the Spotify
backend.

Connections from clients come through an access point, a relatively thin proxy
to various backend services. Services provide authentication, decryption keys,
track information and of course the actual music data, among other things. How
did they configure the whole network of services? They used DNS. It's pretty
easy to store configuration parameters as TXT records in DNS alongside other
records. Access point queries the internal DNS server and then decides where to
connect the incoming request.

Setting up a DNS server is really easy and DNS servers are one of the most
battle tested pieces of code. When was the last time you had to worry about DNS
or heard about DNS server failure? You almost never do, because it just works.
