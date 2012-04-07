---
title: Android radio firmware checksums for Google Nexus One
layout: post
category: blog
tags: [android, eclair, firmware, froyo, mobile, nexusone, radio]
author: Aki Saarinen
published: true
---
I recently needed to downgrade my radio firmware of an european Google Nexus
One for research purposes. To my surprise, HTC or Google didn't provide
official packages of the older radio firmware. If you want to get an older
radio firmware, you're on your own. Only way of getting them is to dig deep
into Android developer forums and download a radio image from unofficial
sources.

Because flashing the radio firmware is one of those things that has a serious
risk of bricking the phone, it's not too fun to try with shady images and see
what happens. If the image is incompatible or damaged, you'll end up with a
brick.

I can't distribute any radio images, because their license doesn't allow
redistribution. But I can publish the checksums of the images I successfully
used, so you can verify the files you've got to see if it's the same that I've
been using. I hope this can be another data point you can use to decide whether
a radio image is reliable or not.

Note that I don't have any visibility what's inside these, they're just a
result of a few days worth of forum searches and experiments. They could even
contain malware. What I can tell is that they did not brick my phone and the
radio was still working after these were in. The checksums are of the radio.img
file only.

I have a newer Nexus One model (the one with SLCD), microp firmware version
0c15, and hboot version 0.35.0017.

#### Radio 5.12.00.08

Tested to work with Android 2.2.1 Froyo (FRG83). 

* MD5: 263fb298d747f9e5632b373c69ce7893
* SHA1: 2ad521b954178f0962d25c13ba45014df7d2c455

#### Radio 5.08.00.04

Tested to work with Android 2.2.1 Froyo (FRG83).

* MD5: dee19eddd42cd0166398bcab37663f62
* SHA1: 802656e261433400d3a56a978b0350b180bc8884

#### Radio 4.04.00.03_2

Tested to work with Android 2.1 Eclair (ERE36B).

* MD5: 310d85c4998163818f7dcdef730c2a12
* SHA1: 1bc692631d33f8b885a5152d602cb3f2e812250d

