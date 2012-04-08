---
title: Booting Android 2.1 in Nexus One with SLCD
layout: post
category: blog
tags: [android, downgrading, eclair, mobile, nexusone]
author: Aki Saarinen
published: true
---
I wanted to downgrade my Google Nexus One momentarily back to stock Android 2.1
(called Eclair), in order to build my own version of the [TaintDroid
system](http://appanalysis.org/). I first needed the stock Eclair to fetch the
proprietary 2.1 compatible libraries from the phone. These libraries are not
allowed to be distributed by anyone but the vendors, which means they are only
embedded into the stock images. I had Android 2.2 installed to the phone, but
the libraries there were incompatible with 2.1.

I wrote this post because there's quite a lot confusing and contradictory
information about downgrading, scattered around various forums. Hopefully
someone can learn from my experiences. I'm using a phone with unlocked
bootloader and most of the tricks only work after unlocking, so if you want to
keep your phone locked, this is not the way for you.

Using these steps I managed to boot up stock 2.1 Eclair in Nexus One, even
though admittedly I not in a 100% working shape. It kept throwing some
exceptions into my face, but it was in a good enough condition to use adb to
download the libraries. After that I successfully compiled and installed the
modified 2.1 in TaintDroid, which worked just fine. Probably the stock
installation could've fixed too, but I didn't invest my time in finding what
was wrong with it.

#### SLCD or AMOLED?

First piece of the puzzle when downgrading is that there are two kinds of Nexus
Ones. An older generation with an AMOLED display and a newer one with an SLCD
display. You can boot up your phone to the bootloader and check microp version
to see which one you have: 0b15 is AMOLED, 0c15 is SLCD.

I have the newer one, which becomes a problem: the kernel in stock Android 2.1
does not support SLCD, so you need to compile a kernel by yourself, as
described later on in the post. Android 2.1 can be booted up with SLCD, you
just have to have support for it in the kernel. I have no experience with the
AMOLED Nexus One, so I'm not sure about that, but I believe it will work
out-of-the-box.

#### Hboot, microp and radio firmware

I had a recent version of the bootloader firmware, also called hboot. My
bootloader is in version 0.35.0017. Some sources claim the newer bootloader
wouldn't work with Eclair. I had no problems with the newer bootloader, so I
have proof that it does work just fine. Nexus one with SLCD also has newer
version of the microp firmware (0c15) than originally used for by Eclair
(0b15), and it also works just fine. No need to worry about those.

A possible troublemaker could be the radio driver. I had some problems along
the way, which led me to downgrade my radio firmware back to 4.04.00.03_2. When
I was all finished, though, I also successfully booted up Eclair with radios
5.08.00.04 and 5.12.00.08, so I believe they should all work and my problems
were cause by other factors at the time. 

If you run into trouble you can't figure out, you can try downgrading the
radio, some checksums of working radio images available in 
[my other post]({% post_url 2011-08-08-android-radio-firmware-checksums-for-google-nexus-one %}).

#### Getting a kernel with SLCD support

In order to boot Android 2.1 Eclair with the SLCD, you need to have a new
enough kernel. I used 2.6.32, newer ones might do as well.

Simplest way to get a working kernel is to use the boot image from Android 2.2
(Froyo) distribution. You can get one for Nexus one from
[developer.htc.com](http://developer.htc.com/). I used [Nexus One FRG83 system
image](http://dl4.htc.com/RomCode/Source_and_Binaries/signed-passion-img-FRG83_0923.zip).
Unzip the zip, and you get a boot.img loaded with 2.6.32 kernel, which you can
eventually flash into the device with 'fastboot flash boot boot.img'.

If you want, you can also compile your own 2.6.32 kernel. This will become
handy (and even a necessity) later on, if you want to customize your platform
at all, but it's not strictly necessary at this point. If you don't want to
compile your own kernel, you can skip the next section.

#### Compiling your own 2.6.32 kernel

A good writeup about how to compile 2.6.32 kernel for Android is available at
[here](http://randomizedsort.blogspot.com/2010/08/building-android-and-linux-kernel-for.html).
First part of the post is about compiling Android 2.2 distribution, but take a
look at the kernel part. After compiling the kernel, you can use 'fastboot boot
/path/to/my/kernel/zImage' to boot up Android with your custom-built kernel
instead of the one flashed to the device. This is a handy way of testing a new
kernel, without having to flash it.

I compiled my kernel while still having Android 2.2.1 installed on the phone.
This was convenient, as the phone already had a 2.6.32 kernel, so I could use
that as a baseline for my kernel configuration. That way I could also modify
one thing at once, so if the system didn't boot, I knew the reason was my
kernel, and the kernel only. Only after having a fully functioning 2.6.32
kernel image did I proceed with installing Eclair.

#### Downloading and flashing stock Eclair image

You can download the stock image for Android 2.1 from
[developer.htc.com](http://developer.htc.com), I used [Nexus One (ERE36B)
Official OS
Image](http://dl4.htc.com/RomCode/Source_and_Binaries/NexusOne_ERE36B_TMOUS.zip).

In order to flash the zip with 'fastboot update NexusOne_ERE36B_TMOUS.zip', you
need to unzip the package, modify android-info.txt so that you allow the newer
bootloader and microp versions (and radio if you didn't downgrade):

    require version-bootloader=0.33.2012|0.33.0012|0.35.0017
    require version-microp=0b15|0c15
    require version-baseband=4.04.00.03_2|5.12.00.08

...and then zip it back in. 

This will just tell fastboot that you want to flash the images even though you
have a newer bootloader, microp and radio versions. I'm not that experienced on
this subject, so I'm not 100% sure if there's a way this can screw things
(flashing always has a hint of danger to it), but I had no problems myself. I
believe this to be safe, if the flashing is done properly, but be warned
though, I'm not going to take the blame if you brick your phone.

#### Booting Eclair with custom kernel

After flashing the stock Eclair, you can try booting up the phone, but with an
SLCD you'll end up with a black screen. My phone also seemed to jam up so I had
to take out the battery before being able to reset it.

What you need now, is the 2.6.32 kernel image. If you want to use the one from
stock Froyo, just issue 'fastboot flash boot boot.img' for the boot-image
coming with froyo and you should be good to go.

If you compiled it yourself, simplest way is to use 'fastboot boot
myKernelImage', so you don't have to craft a boot.img to be flashed. If you
want to be able to boot the 2.1 without some assistance from a computer and the
fastboot utility, you'll need to do that eventually, too. I didn't because I
only used the stock 2.1 for a while in order to fetch the proprietary drivers.

#### Fixing network drivers

Since the bundled bcm4329 network device driver in the system image is compiled
to work with the exact kernel version thats bundled with the distribution, it
won't work when booting up with a different kernel using 'fastboot boot'. To
make networking work, you need to patch the bcm4329.ko from your custom kernel
to the system partition of the phone, where it's loaded from in the boot
procedure. This might apply to other drivers too, however I was only
experiencing problems with networking. If you only want to fetch the
proprietary drivers, you won't even need the networking, anyway.

#### A working Android 2.1 in Nexus One

If everything went well, you should now have booted up stock Android 2.1 in
your Nexus One. Happy hacking, whatever it is you wish to do with it!
