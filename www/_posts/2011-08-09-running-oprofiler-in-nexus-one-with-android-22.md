---
title: Running oprofiler in Nexus One with Android 2.2
layout: post
category: blog
tags: [android, froyo, mobile, oprofiler, performance, profiling]
author: Aki Saarinen
published: true
---
[Oprofiler](http://oprofile.sourceforge.net/) is a system-wide profiling tool
for Linux that utilizes [hardware performance
counters](http://en.wikipedia.org/wiki/Hardware_performance_counter) in the CPU
to provide a wide range of interesting statistics about program execution.
Oprofiler is not enabled in the standard Android distribution, but with some
modifications, it can be used under Android also.

I was able to run oprofiler under Nexus One and Android 2.2, with one
limitation. I could only profile once after a restart, further attempts to
start the profiler would not succeed in collecting any data. This limits the
usability of oprofiler, but it was enough for my immediate profiling needs. If
you manage to fix this issue, let me know.

#### Compile kernel with support for profiling 

Oprofiler needs support in the Linux kernel, and the prebuilt kernel for Nexus
One doesn't include this support. You need to compile your own version of the
Android kernel for your device, with profiling support enabled.

You can check what kernel version your phone is currently running from
Settings->About Phone. I suggest you try to compile the same version of the
kernel that the phone is running as default. A good article about building the
kernel and platform for Nexus One is available here. I used kernel version
2.6.32 for my phone with Android Froyo 2.2 (FRG83).

You should use standard kernel configuration tools ("make menuconfig") to
enable the support, but you can compare results with [this
patch](http://akisaarinen.fi/public/android/profiling-support-to-2.6.32.patch)
to see you're enabling the right things
([CONFIG_OPROFILE](http://cateee.net/lkddb/web-lkddb/OPROFILE.html), etc).

In order to keep the kernel small enough (there's a limitation what can be fit
into the phone), I additionally needed to disable ext3 and ext2 support.

#### Interrupt bug in 2.6.32 kernel for Nexus One 

Oprofiler module in 2.6.32 kernel is missing an interrupt for Nexus One CPU.
The bug is
[discussed](http://groups.google.com/group/android-platform/browse_thread/thread/3f17699acfbd3f04/81d79fcb3a2412a7)
in the android-platform mailing list and original patch are available
[here](https://review.source.android.com/15707). I also have a [mirror of the
patch](http://akisaarinen.fi/public/android/oprofiler-interrupt-2.6.32.patch),
just in case. Apply the patch, include the kernel with your custom Android 2.2
distribution and start profiling.

