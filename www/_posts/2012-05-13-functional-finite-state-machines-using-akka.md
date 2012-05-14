---
title: Functional Finite-state Machines using Akka
layout: post
category: blog
tags: [functional, fsm, akka, actors, erlang, scala]
author: Aki Saarinen
published: true
---

This post is about combining functional programming, finite-state machines and
the actor model of computation using [Akka
FSM](http://doc.akka.io/docs/akka/snapshot/scala/fsm.html).

[Finite-state machine](http://en.wikipedia.org/wiki/Finite-state_machine), or
FSM for short, is a mathematical model for structuring a computer program. Many
programmers have come across them, either in a CS course in university or in
practical applications. FSM is a useful tool, because it forces the programmer
to lay out the states and flow between them explicitly. I often use FSMs as a
mental model for reasoning about programs, even if the program would not be
explicitly structures as one.

[Actor model of computation](http://en.wikipedia.org/wiki/Actor_model),
extensively used in e.g. [Erlang](http://www.erlang.org/), is another
interesting concept: application is modelled as a group of independent actors,
who only communicate with each other using asynchronous message passing.
Actors are an old concept, first presented in 1973, but are becoming
increasingly popular as a way of handling concurrency and parallelism as
the number of cores increase.  There is [a great talk about
actors](http://channel9.msdn.com/%28A%28DIZWlv8LzQEkAAAAOTQ0NWI2ZTUtM2ZlYS00Yjg1LTg4NzMtNzJhZjA1MmUwZmMxAmqfHykWJRBKmZh75HL0--PjXeY1%29%29/Shows/Going+Deep/Hewitt-Meijer-and-Szyperski-The-Actor-Model-everything-you-wanted-to-know-but-were-afraid-to-ask)
on Channel 9, involving [Carl Hewitt](http://carlhewitt.info/), the inventor of
actors, and [Eric
Meijer](http://en.wikipedia.org/wiki/Erik_Meijer_%28computer_scientist%29) from
Microsoft Research. I recommend watching it, regardless of your level of
experience with the actor model. 

Regarding the third component in this post, functional programming, Michael
Feathers recently wrote about [hybridizing object-oriented and functional
design](http://michaelfeathers.typepad.com/michael_feathers_blog/2012/03/tell-above-and-ask-below-hybridizing-oo-and-functional-design.html):

> Object-orientation is better for the higher levels of a system, and
> functional programming is better for the lower levels.

Michael throws in the usual disclaimers about this not applying to every case,
to which I agree, but I still think there is something to it. I *love* 
functional programming: filtering, mapping and folding lists allow me to write
very concise code, fast. However, pure code with no side-effects is ultimately
of no use on itself: someone somewhere must see the results. How to orchestrate
the side-effects and build the larger application around the functional pieces
is a very interesting question, one which does not have a clear-cut answer.

In the spirit of Michael's post, but instead of using traditional objects on
the higher level, could we structure the application as a set of functional
finite-state machine actors? Independent entities, whose behaviour is well
specified in terms of states and state transitions. Entities which communicate
asynchronously using actor message passing. Entities whose state transitions
are written as purely functional pieces of code. This seems like an intriguing
concept.

The idea itself is nothing new. The [Erlang design
principles](http://www.erlang.org/documentation/doc-4.8.2/doc/design_principles/fsm.html),
for example, describe how to implement finite-state machines using Erlang
actors. I have, however, rarely seen this as the base for application design.

A few weeks ago I was excited to find [Akka
FSM](http://doc.akka.io/docs/akka/snapshot/scala/fsm.html), a finite-state
machine implementation library for Akka, an actor framework for
[Scala](http://scala-lang.org). 

Scala is well suited for functional programming, and Akka FSM does hence
provide the possibility to combine the aforementioned three pieces into a
single clean package: implementing the application as a set of actors which are
internally functional finite-state machines. I have been writing code using
Akka FSM for a few weeks now, and it seems like a natural way of structuring
programs. So far I am very pleased.

The official documentation contains [plenty of
examples](http://doc.akka.io/docs/akka/snapshot/scala/fsm.html#A_Simple_Example),
so I won't replicate them here. Check the docs and give it a go.

