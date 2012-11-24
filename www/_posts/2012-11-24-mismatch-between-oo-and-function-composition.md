---
title:     The mismatch between OO design and function composition
layout:    post
category:  blog
tags:      [scala, functional programming, object-oriented, function composition]
author:    Aki Saarinen
published: true
---

Scala is a multi-paradigm language, giving developers the ability to mix both
functional and object-oriented designs.

Combining these two can be painful. I have a hunch that part of this friction
comes from the difficulty of using function composition together with
object-oriented designs.

It's not that you can't combine these two, it's just that OO designs nudge you
away from function composition. This post is trying to exemplify that mismatch.

#### Implicit receivers lead to method chaining

Methods of a class (in object-oriented sense) are functions, which have one
implicit parameter, `this`. They are always tied to a specific instance of the
class.

Let's look at a simple example. Say we want to implement a numerical algorithm,
which first adds 8 to a number, then takes the square root and sine of the
result.

Also, for the sake of making of a point, let's assume we are implementing this
API ourselves and won't rely on any standard library interfaces. I'm only using
standard library in the implementations.

I am assuming we are civilized people here and don't implement this by mutating
the state of `Number`, but return a new immutable instance. This is what our
OO solution could look like:

{% highlight scala %}
object OO {
  class Number(val value: Double) {
    def add(x: Double) = new Number(value + x)
    def sqrt           = new Number(math.sqrt(value))
    def sin            = new Number(math.sin(value))
  }

  def algorithm(x: Number) = x.add(8).sqrt.sin

  val result = algorithm(new Number(17)).value
}
{% endhighlight %}

#### Functions lead to new functions

If we would write this in a purely functional manner, i.e. not
binding the implicit receiver, a comparable solution in Scala would
look something like this:

{% highlight scala %}
object FP {
  type Number = Double

  def add(x: Number)  = x + 8
  def sqrt(x: Number) = math.sqrt(x)
  def sin(x: Number)  = math.sin(x)

  def algorithm = (add(_)) andThen (sqrt(_)) andThen (sin(_))

  val result = algorithm(17)
}
{% endhighlight %}

#### Where's the difference?

Now, these solutions both give you the same result, `-0.9589242746631385`.
They also look kind of similar, both having a chain of `add`, `sqrt` and `sin`
in the algorithm part.

There are conceptual differences, though. In the OO version, the algorithm is
constructed by chaining a sequence of method calls for the given instance of
`Number`. To do this, we naturally need to have a handle to the instance of
`Number`. That's where the chaining starts.

In the FP version, we are taking functions, and creating a new function without
ever needing to know the instance of `Number` while doing the composition. The
parts we are composing don't have to have anything in common, but we can still
compose them to create a new function. In this sense function composition
is more flexible.

#### Which one is better?

The disappointing answer is that it depends. I think the functional approach is
more flexible, and when I'm writing Scala I try to start with that, but there
is no single answer as what to do.

The thing to keep in mind is that when you write something in Scala as a method
(or a function), *you are making a choice*. You define what will be the most
natural way of using your piece of code. 

The natural way of using methods will be to chain calls on object instances.
Functions, on the other hand, will naturally lead you into thinking about new
functions.

Now, what do you want to see done in your codebase?
