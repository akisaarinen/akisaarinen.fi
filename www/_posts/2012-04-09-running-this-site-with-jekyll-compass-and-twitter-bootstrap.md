---
title: Running this site with Jekyll, Compass and Twitter Bootstrap
layout: post
category: blog
tags: [jekyll, compass, sass, bootstrap]
author: Aki Saarinen
published: true
---

During the Easter holidays I updated the technology for this site.

My goal was to find a simple and elegant solution for hosting two things: [my
static home page](http://akisaarinen.fi) and this blog. Until yesterday, the
blog was hosted at [Posterous](http://posterous.com). Posterous was recently
[acquired by Twitter](http://blog.posterous.com/big-news) for their talent,
which means the service is likely no longer actively developed. On a related
note, there was [good discussion](http://news.ycombinator.com/item?id=3695407)
in Hacker News about talent acquisitions.

In addition to the fact that Posterous platform is dying, I was never really
happy with writing the blog posts in a WYSIWYGish web interface. Writing in
[Vim](http://www.vim.org/) with basic
[Markdown](http://daringfireball.net/projects/markdown/) syntax is an
attractive alternative.

Here's what I came up with. A pretty standard stack these days, I guess. I have
been reading about almost all of these tools for a while and it was
nice to see how well everything worked. Not always the case with
hyped tools.

Everything is based on the static site generator,
[Jekyll](http://jekyllrb.com/). Installation is straightforward using RubyGems,
just install RubyGems in your preferred way and run `gem install jekyll`. Then
all you need to do is run `jekyll` and the whole site is compiled to static
HTML, ready to be hosted where ever you want. I am using
[Kapsi](http://www.kapsi.fi) for hosting, but basically any provider, like
[Github pages](http://pages.github.com/) or [Heroku](http://www.heroku.com/)
would do. Nice thing about this setup is that it requires nothing except a
basic HTTP server from the hosting provider.

Jekyll contains support for
[Markdown](http://daringfireball.net/projects/markdown/) based page rendering
and [Liquid](http://liquidmarkup.org/) templates out-of-the-box. There are at
least two major projects that try to bring one-click blog hosting around
Jekyll: [Octopress](http://octopress.org/) and
[Jekyll-Bootstrap](http://jekyllbootstrap.com/). I decided against using these,
for two reasons. First, I wanted to keep things as simple as possible and
second, I wanted to learn in the process.

To make the site look like it does, I used two tools:
[Compass](http://compass-style.org/) and [Twitter
Bootstrap](http://twitter.github.com/bootstrap/).

Compass is a CSS Authoring Framework, as they call it. In practice, it lets me
write style sheets in [Sass](http://sass-lang.com/). Sass an excension of CSS3
which compass then compiles to standard CSS3. End result is cleaner stylesheet
syntax and less duplication than with traditional CSS files. Being also a
rubygem, installation is again simple: `gem install compass`.

Basic layout is achieved using Twitter Bootstrap styles, with some custom CSS
thrown in. In case you are not already familiar with Bootstrap, I suggest you
[take a look](http://twitter.github.com/bootstrap/).

Sources are hosted in [a git
repository](http://github.com/akisaarinen/akisaarinen.fi) and deployed to
production using a simple shell script. Previewing posts and changes locally is
easy:

    compass watch
    jekyll --server --auto

This results into compass watching for changes in Sass files and compiling them
to CSS as soon as the file is modified. Jekyll starts a standalone HTTP server
in port 4000 and lets me preview the latest changes by accessing
http://localhost:4000/. The `--auto` flag automatically re-compiles the site as
soon as there are any changes. 

The feedback loop for testing is extremely fast, something I value a lot.
Writing and publishing this blog post is now all sunshine and happiness.

