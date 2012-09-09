---
title:     Haskellify your Scala
layout:    post
category:  blog
tags:      [functional programming, scala, haskell]
author:    Aki Saarinen
published: true
---

After working with [Scala][scala] daily for almost 3 years, I am still
struggling to find the best practices for using it. Scala is a language of many
choices and compromises: it does not do much to enforce a certain style.

One of the better guidelines was suggested by my colleagues,
[Pekka Enberg][penberg] and [Jussi Virtanen][jussi_v]

> Always consider what you would do in Haskell.

Let's take an example.

#### Separate data and logic

In Haskell, the first step to solving any problem is to design the data types.
That is followed by writing an appropriate set of [referentially transparent][ref_tp]
functions, which transform that data model as necessary. A very clear
separation of data and logic.

In imperative object-oriented programming, data and logic are more mixed.
Classes contain data, but also provide the operations for manipulating that
data.

How to apply the Haskell principle to Scala? One concrete example is that case
classes should only contain data, while data manipulation functions live their
own life in the companion object.

Here's an example:

    case class Portfolio(positions: Map[Instrument, Quantity]) {
      def get(instrument: Instrument): Quantity = positions.getOrElse(instrument, 0L)
    }

    object Portfolio {
      def add(a: Portfolio, b: Portfolio): Portfolio = {
        // whatever (sometimes complex) logic to add two portfolios
      }
      def substract(a: Portfolio, b: Portfolio): Portfolio = {
        // whatever (sometimes complex) logic to substract two portfolios
      }
    }

Complex portfolio manipulation functions are not part of `Portfolio` case
class, but part of the companion object instead. This provides a natural
separation for data and logic. The example also contains one instance method,
`get`, for the case class. There are two reasons for that. First, it is
effectively part of the data model by defining the values for non-defined
instruments. Second, it keeps the code using portfolios concise because `get`
is called repeatedly for Portfolio objects all over the place.

To put this simply:

> Do not write data manipulation logic to case classes

Following this convention establishes two things:

* When writing code, it encourages to focus more on the data model
* When reading and reviewing the code, the data model is more visible

While Haskell does not always have the right answers, keeping it as a role
model certainly guides you towards more functional and data-oriented habits.
Hence when writing scala, always imagine what you would do in Haskell. After
that, use your judgement.

[penberg]: https://twitter.com/penberg
[jussi_v]: https://twitter.com/jussi_v
[scala]:   http://scala-lang.org "Scala"
[ref_tp]:  http://en.wikipedia.org/wiki/Referential_transparency_(computer_science)  "Referential transparency (computer science)"
