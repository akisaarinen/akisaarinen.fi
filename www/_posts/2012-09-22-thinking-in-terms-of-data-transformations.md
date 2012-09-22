---
title:     Thinking in terms of data transformations
layout:    post
category:  blog
tags:      [functional programming, scala, haskell]
author:    Aki Saarinen
published: true
---

This is a successor to my previous post, [Haskellify your Scala][haskellify],
giving another example of how to design Scala in a Haskellish fashion. I am
describing a way of thinking design in terms of data transformations, instead of a
sequence of instructions to mutate state.

[Imperative programming][imperative] focuses on executing a series of
statements to mutate the program state into something desirable. It is
fundamentally based on the idea of executing instructions on the CPU. Modern
languages provide high level abstractions for specifying the instructions, of
course. Java programmers rarely need to care about the Java
bytecode instructions [^perf], and even less so about the actual CPU
instructions. 

However, none of these abstractions change the underlying mindset. The program
is still a sequence of statements, albeit well structured sequence of
statements, that are executed in the defined order to achieve the goal.

Functional programming offers a different way of reasoning about programs.
Instead of thinking in terms of sequential statements, programs can be viewed
as ways of transforming input data into something more useful than the input
itself. 

It's about first modelling the problem by defining appropriate data structures,
such as lists, queues and trees, and then defining functions, which transform
this data.

#### A tale of two Pong bots

To illustrate my point, I'll show you two imaginary designs that could take
part in the [Hello World Open][hwo] competition. In Hello World Open,
programmers compete against each other by writing bots for the game of
[Pong][pong]. Bots receive events over the network about the current state of
the game, while controlling their own paddle by sending commands to the server.

The point of this example is not to describe a great Pong bot, but the
difference between designing imperatively and functionally. I am presenting two
ways of structuring a Pong bot in Scala. 

An imperative approach to implementing the core bot logic and the main loop
could look something like this ([Full source as Gist][bot_imperative]).

<div class="highlight"><pre><span class="k">class</span> <span class="nc">Bot</span><span class="o">(</span><span class="n">connection</span><span class="k">:</span> <span class="kt">PongConnection</span><span class="o">)</span> <span class="o">{</span>
  <span class="k">var</span> <span class="n">myDirection</span>      <span class="k">=</span> <span class="mi">0</span>
  <span class="k">var</span> <span class="n">missileInventory</span> <span class="k">=</span> <span class="mi">0</span>
  <span class="k">var</span> <span class="n">enemyPosition</span>    <span class="k">=</span> <span class="mi">0</span>

  <span class="k">def</span> <span class="n">update</span><span class="o">(</span><span class="n">event</span><span class="k">:</span> <span class="kt">Event</span><span class="o">)</span> <span class="o">{</span>
    <span class="k">if</span> <span class="o">(</span><span class="n">conditionA</span><span class="o">(</span><span class="n">event</span><span class="o">))</span> <span class="o">{</span>
      <span class="n">goUp</span><span class="o">()</span>
    <span class="o">}</span> <span class="k">else</span> <span class="k">if</span> <span class="o">(</span><span class="n">conditionB</span><span class="o">(</span><span class="n">event</span><span class="o">))</span> <span class="o">{</span>
      <span class="n">shootMissile</span><span class="o">()</span>
    <span class="o">}</span>
  <span class="o">}</span> 
    
  <span class="k">private</span> <span class="k">def</span> <span class="n">goUp</span><span class="o">()</span> <span class="o">{</span>
    <span class="n">myDirection</span> <span class="k">=</span> <span class="mi">1</span>
    <span class="n">connection</span><span class="o">.</span><span class="n">moveUp</span><span class="o">()</span>
  <span class="o">}</span>

  <span class="k">private</span> <span class="k">def</span> <span class="n">shootMissile</span><span class="o">()</span> <span class="o">{</span>
    <span class="n">missileInventory</span> <span class="o">-=</span> <span class="mi">1</span>
    <span class="n">connection</span><span class="o">.</span><span class="n">shootMissile</span><span class="o">()</span>
  <span class="o">}</span>
  
  <span class="k">private</span> <span class="k">def</span> <span class="n">conditionA</span><span class="o">(</span><span class="n">event</span><span class="k">:</span> <span class="kt">Event</span><span class="o">)</span><span class="k">:</span> <span class="kt">Boolean</span> <span class="o">=</span> <span class="n">sys</span><span class="o">.</span><span class="n">error</span><span class="o">(</span><span class="s">&quot;not implemented&quot;</span><span class="o">)</span>
  <span class="k">private</span> <span class="k">def</span> <span class="n">conditionB</span><span class="o">(</span><span class="n">event</span><span class="k">:</span> <span class="kt">Event</span><span class="o">)</span><span class="k">:</span> <span class="kt">Boolean</span> <span class="o">=</span> <span class="n">sys</span><span class="o">.</span><span class="n">error</span><span class="o">(</span><span class="s">&quot;not implemented&quot;</span><span class="o">)</span>
<span class="o">}</span>

<span class="k">object</span> <span class="nc">Pong</span> <span class="k">extends</span> <span class="nc">App</span> <span class="o">{</span>
  <span class="k">val</span> <span class="n">connection</span> <span class="k">=</span> <span class="k">new</span> <span class="nc">PongConnection</span>
  <span class="k">val</span> <span class="n">bot</span>        <span class="k">=</span> <span class="k">new</span> <span class="nc">Bot</span><span class="o">(</span><span class="n">connection</span><span class="o">)</span>
  <span class="k">while</span> <span class="o">(</span><span class="n">connection</span><span class="o">.</span><span class="n">isConnected</span><span class="o">())</span> <span class="o">{</span>
    <span class="k">val</span> <span class="n">event</span> <span class="k">=</span> <span class="n">connection</span><span class="o">.</span><span class="n">readEvent</span><span class="o">()</span>
    <span class="n">bot</span><span class="o">.</span><span class="n">update</span><span class="o">(</span><span class="n">event</span><span class="o">)</span>
  <span class="o">}</span>
<span class="o">}</span> 
</pre></div>

A functional version, structured around the idea of transforming data, could
look more like this ([Full source as Gist][bot_functional]).

<div class="highlight"><pre><span class="k">object</span> <span class="nc">Bot</span> <span class="o">{</span>
  <span class="k">def</span> <span class="n">actions</span><span class="o">(</span><span class="n">state</span><span class="k">:</span> <span class="kt">State</span><span class="o">,</span> <span class="n">event</span><span class="k">:</span> <span class="kt">Event</span><span class="o">)</span><span class="k">:</span> <span class="o">(</span><span class="kt">State</span><span class="o">,</span> <span class="kt">Seq</span><span class="o">[</span><span class="kt">Action</span><span class="o">])</span> <span class="k">=</span> <span class="o">(</span><span class="n">state</span><span class="o">,</span> <span class="n">event</span><span class="o">)</span> <span class="k">match</span> <span class="o">{</span>
    <span class="k">case</span> <span class="o">(</span><span class="n">s</span><span class="o">,</span><span class="n">e</span><span class="o">)</span> <span class="k">if</span> <span class="n">conditionA</span><span class="o">(</span><span class="n">s</span><span class="o">,</span><span class="n">e</span><span class="o">)</span> <span class="k">=&gt;</span> <span class="nc">State</span><span class="o">.</span><span class="n">up</span><span class="o">(</span><span class="n">state</span><span class="o">)</span>    <span class="o">-&gt;</span> <span class="nc">Actions</span><span class="o">.</span><span class="n">up</span>
    <span class="k">case</span> <span class="o">(</span><span class="n">s</span><span class="o">,</span><span class="n">e</span><span class="o">)</span> <span class="k">if</span> <span class="n">conditionB</span><span class="o">(</span><span class="n">s</span><span class="o">,</span><span class="n">e</span><span class="o">)</span> <span class="k">=&gt;</span> <span class="nc">State</span><span class="o">.</span><span class="n">shoot</span><span class="o">(</span><span class="n">state</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="nc">Actions</span><span class="o">.</span><span class="n">shoot</span>
    <span class="k">case</span> <span class="k">_</span>                        <span class="k">=&gt;</span> <span class="n">state</span>              <span class="o">-&gt;</span> <span class="nc">Actions</span><span class="o">.</span><span class="n">none</span>
  <span class="o">}</span>

  <span class="k">def</span> <span class="n">conditionA</span><span class="o">(</span><span class="n">state</span><span class="k">:</span> <span class="kt">State</span><span class="o">,</span> <span class="n">event</span><span class="k">:</span> <span class="kt">Event</span><span class="o">)</span><span class="k">:</span> <span class="kt">Boolean</span> <span class="o">=</span> <span class="n">sys</span><span class="o">.</span><span class="n">error</span><span class="o">(</span><span class="s">&quot;not implemented&quot;</span><span class="o">)</span>
  <span class="k">def</span> <span class="n">conditionB</span><span class="o">(</span><span class="n">state</span><span class="k">:</span> <span class="kt">State</span><span class="o">,</span> <span class="n">event</span><span class="k">:</span> <span class="kt">Event</span><span class="o">)</span><span class="k">:</span> <span class="kt">Boolean</span> <span class="o">=</span> <span class="n">sys</span><span class="o">.</span><span class="n">error</span><span class="o">(</span><span class="s">&quot;not implemented&quot;</span><span class="o">)</span>
<span class="o">}</span>

<span class="k">object</span> <span class="nc">Pong</span> <span class="k">extends</span> <span class="nc">App</span> <span class="o">{</span>
  <span class="k">val</span> <span class="n">events</span>       <span class="k">=</span> <span class="n">createSource</span><span class="o">()</span>
  <span class="k">val</span> <span class="n">initialState</span> <span class="k">=</span> <span class="nc">State</span><span class="o">()</span>
  
  <span class="n">events</span><span class="o">.</span><span class="n">foldLeft</span><span class="o">(</span><span class="n">initialState</span><span class="o">)</span> <span class="o">{</span> <span class="k">case</span> <span class="o">(</span><span class="n">state</span><span class="o">,</span> <span class="n">msg</span><span class="o">)</span> <span class="k">=&gt;</span>
    <span class="k">val</span> <span class="o">(</span><span class="n">newState</span><span class="o">,</span> <span class="n">actions</span><span class="o">)</span> <span class="k">=</span> <span class="nc">Bot</span><span class="o">.</span><span class="n">actions</span><span class="o">(</span><span class="n">state</span><span class="o">,</span> <span class="n">msg</span><span class="o">)</span>
    <span class="n">actions</span><span class="o">.</span><span class="n">foreach</span><span class="o">(</span><span class="n">execute</span><span class="o">)</span>
    <span class="n">newState</span>
  <span class="o">}</span>

  <span class="k">private</span> <span class="k">def</span> <span class="n">createSource</span><span class="o">()</span><span class="k">:</span> <span class="kt">Iterator</span><span class="o">[</span><span class="kt">Event</span><span class="o">]</span> <span class="k">=</span> <span class="n">sys</span><span class="o">.</span><span class="n">error</span><span class="o">(</span><span class="s">&quot;not implemented&quot;</span><span class="o">)</span>
  <span class="k">private</span> <span class="k">def</span> <span class="n">execute</span><span class="o">(</span><span class="n">action</span><span class="k">:</span> <span class="kt">Action</span><span class="o">)</span> <span class="k">=</span> <span class="n">sys</span><span class="o">.</span><span class="n">error</span><span class="o">(</span><span class="s">&quot;not implemented&quot;</span><span class="o">)</span>
<span class="o">}</span>
</pre></div>

#### Key differences in the two designs

There are countless ways of making both of these implementations better, but I
want to concentrate on the key differences between the thought process behind
them. This is not a competition between the imperative and the functional
version, but an illustration of the differences.

The functional version is built around the concept of transforming the current
state and incoming event into a sequence of formalized actions. The imperative
version, on the other hand, is executing a series of instructions by calling
other objects, in hopes of leading the bot to a victory.

Structuring program as data transformations leads to some nice things. In the
functional version it's easy to isolate all side-effects out of the core bot
logic. The decision function is only transforming `(State, Event)` tuples into
new a new state and a sequence of Actions. The imperative version, in contrast,
is using `Connection` to move our world into the desired new state. Nothing
prevents you from implementing similar separations for the imperative version,
but it usually doesn't feel as natural.

Functional data transformations are also conveniently testable using techniques
like [ScalaCheck][scalacheck]. It generates a set of random inputs and asserts
that given properties are true for all outputs. Similar testing is harder to
achieve for imperative code, even if you would utilize e.g. mock objects.

#### Summary

Thinking in terms of data transformations can lead to better designs. It is one
of the ways you can [Haskellify][haskellify] Scala code. Transformations, and
the data-centric approach in general, forces you to clarify and formalize
concepts. It also makes isolating side-effects easy.

[haskellify]: {% post_url 2012-09-10-haskellify-your-scala %}
[imperative]: http://en.wikipedia.org/wiki/Imperative_programming
[javap]: http://docs.oracle.com/javase/7/docs/technotes/tools/solaris/javap.html
[hwo]: http://helloworldopen.fi/
[pong]: http://en.wikipedia.org/wiki/Pong
[ref_tp]: http://en.wikipedia.org/wiki/Referential_transparency_(computer_science)
[bot_imperative]: https://gist.github.com/3766321
[bot_functional]: https://gist.github.com/3766325
[scalacheck]: https://github.com/rickynils/scalacheck

[^perf]: Unless you're doing performance optimizations, at which point 
         [javap][javap] becomes an invaluable tool, especially with Scala.
         I could rant a lot about this, but this is not the post for
         that :)
