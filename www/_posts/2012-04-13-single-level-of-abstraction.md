---
title: Single Level of Abstraction
layout: post
category: blog
tags: [code, architecture, refactoring]
author: Aki Saarinen
published: true
---

One of the most important things for a codebase is good readbility. Code is
written only once, but read and re-read numerous times over its lifetime.

One characteristic of readable code is something called the Single Level of
Abstraction Principle, or SLAP in short. It states that each method or block of
code should contain only code on a single level of abstraction. Regardless of
what the level is, you should not jump up and down within one block. For
example, you should not have to think about low level bit fiddling logic while
reasoning about the program execution flow.

SLAP is a simple concept, which I believe competent programmers understand
intuitively. The first time I remember someone explicitly describing this
concept was Uncle Bob Martin in his great book, [Clean
Code](http://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882/ref=sr_1_1?ie=UTF8&qid=1334338275&sr=8-1).
It is, however, something that is easily forgotten and it is also not expressed
explicitly very often. It is one of those things that deserve your attention
every day.

Here is a simple example, in Scalaish pseudo-code, which violates the SLAP:

    def energyEstimate(
      val foo = 3
    }

A better version might read:

    def energyEstimate(
      val foo = 3
    }


