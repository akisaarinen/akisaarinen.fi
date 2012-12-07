---
title:     Boilerplate-free Functional Lenses for Scala
layout:    post
category:  blog
tags:      [scala, functional programming, lenses, rillit]
author:    Aki Saarinen
published: true
---

This post introduces boilerplate-free functional lens creation to Scala using
a library called [Rillit][rillit]. Lenses are composable getters and setters
for immutable data structures, which can significantly ease your pain when
writing functional code. [Rillit][rillit] makes lens creation easier than
any other lens library I know of by utilizing new features from Scala 2.10:
[macros][macros] and [dynamic invocations][dynamic].

#### Why lenses?

Say you have the following case class structure for describing a person. The
nesting seems unncessary in this small example, but that's what you need to do
with larger data structures, so bear with me:

{% highlight scala %}
case class Email(user: String, domain: String)
case class Contact(email: Email, web: String)
case class Person(name: String, contact: Contact)

val person = Person(
  name = "Aki Saarinen",
  contact = Contact(
    email = Email("aki", "akisaarinen.fi"),
    web   = "http://akisaarinen.fi"
  )
)
{% endhighlight %}

Now, say you want to modify the `user` of the email address from 'aki' to
'john'. And because we're working with immutable data structures, we can't just
assign a new value, but we want to create a new instance of `Person` with the
`user` field updated. This is a common pattern when writing functional code.

Here's the idiomatic solution using the `copy` method provided by case classes:

{% highlight scala %}
scala> person.copy(contact = person.contact.copy(email = person.contact.email.copy(user = "john")))
res0: Person = Person(Aki Saarinen,Contact(Email(john,akisaarinen.fi),http://akisaarinen.fi))
{% endhighlight %}

The field gets updated, but the syntax is verbose and ugly. Lenses can ease the
pain. They provide a lens to a certain part of a larger immutable data
structure, allowing you to get and set that particular value.

#### The beauty of Rillit

This is what you could do in Rillit:

{% highlight scala %}
scala> Lenser[Person].contact.email.user.set(person, "john")
res1: Person = Person(Aki Saarinen,Contact(Email(john,akisaarinen.fi),http://akisaarinen.fi))
{% endhighlight %}

This performs the exact same thing as our nested `copy` soup above, but looks a
lot more civilized.

Now, what exactly just happened there? `Lenser` creates a new lens for your
`user` field using a combination of [macros][macros], [dynamic
invocations][dynamic] and implicit conversions. 

Lenses in Rillit are defined as follows (with some irrelevant details omitted):

{% highlight scala %}
trait Lens[A, B] {
  def get(x: A): B
  def set(x: A, v: B): A
}
{% endhighlight %}

A `Lens` provides a view to a particular part of a larger immutable data
structure. In our example the larger part, `A`,  is a `Person` and the lensed
part, `B`, is the user of the email (whose type is a `String`).

A lens can be used to `get` or `set` the part of `Person` that it points to.
Exactly what happened in our example above. And the cool thing is that Rillit's
`Lenser` gives you an easy way to build lenses to arbitrary nested case
classes.

Let's split the earlier expression so it's easier to understand what happens:

{% highlight scala %}
val lenser = Lenser[Person]
val userLens = lenser.contact.email.user
val updatedPerson = userLens.set(person, "john")
{% endhighlight %}

So we first instantiate a `Lenser` for `Person`, then describe the fields for
which this lens should be built (this is all type-safe, done in compile-time
using macros), and finally use that lenser to create a new `Person` with
username updated.  If you want to know the details how the Lenser works, [look
at the source][rillit] Luke.

#### What's next?

There is a lot more benefits to using lenses than just getting rid of ugly
`copy`s. You can for example compose your lenses together, forming new lenses.

There are also many other implementations of lenses for Scala, including ones in
[Scalaz][scalaz], [Shapeless][shapeless] and [Macrocosm][macrocosm]. At the
moment they have far more advanced lens implementations than Rillit, except for
one part: their creation of lenses requires more boilerplate. So I focused on
implementing a boilerplate-free `Lenser`.

As lenses seem an incredibly useful feature in functional programming, I would
hope to see a boilerplate-free, production-ready, stand-alone lens library for
Scala soon after 2.10 is released. I'm planning on using [Rillit][rillit] for
myself, we'll see if someone else is interested in it as well. And maybe the
same `Lenser` approach could be adopted to fit Scalaz and Shapeless as well.

Oh, and the name, Rillit? It's Finnish for glasses, and happens to sound funny
to me.

[rillit]: http://github.com/akisaarinen/rillit
[macros]: http://www.scalamacros.org
[dynamic]: http://www.scala-lang.org/archives/downloads/distrib/files/nightly/docs/library/index.html#scala.Dynamic
[scalaz]: https://github.com/scalaz/scalaz
[shapeless]: https://github.com/milessabin/shapeless
[macrocosm]: https://github.com/retronym/macrocosm
