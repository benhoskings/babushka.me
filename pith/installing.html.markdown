---
layout: "/_layout.html.haml"
title: Installing babushka
---

You can install babushka on your system, no matter what state it's in, using `babushka.me/up`. That's a script that knows enough to install ruby if required (babushka's only runtime dependency), and then download a temporary babushka that knows how to do the proper install.

All you need is something that can fetch over https. Mac OS X and some Linux distros ship with `curl`:

    sh -c "`curl https://babushka.me/up`"

Some other Linux distros have `wget` instead. Linux VPSes with only `wget` installed usually don't have openssl, which means no https downloads. You could install curl first (which should pull in openssl):

    apt-get install -y curl && sh -c "`curl https://babushka.me/up`"

Or just cowboy it over `http://` with wget.

    sh -c "`wget -O - babushka.me/up`" # Hijack me, please!


## What it does

- Installs ruby & curl via your package manager, as required
- Downloads a tarball of babushka from github
- Runs `babushka babushka` to do the actual install, which:
  - Installs git via your package manager, as required
  - Clones the babushka repo to `/usr/local/babushka`, or whatever you choose
  - Symlinks the binary to `/usr/local/bin`


## Scripting the install

The bootstrap script prompts for confirmation and an install prefix. If you're scripting the install, fear not: it runs unconditionally, accepting the defaults for those prompts, if STDIN isn't attached to a terminal. If you'd like to run a prompt-less install at the terminal, just attach `STDIN` to `/dev/null` instead:

    sh -c "`curl babushka.me/up`" </dev/null


## Versions

You can pass a git ref to `babushka.me/up` to install a different babushka version. The default is `stable`.

    sh -c "`curl babushka.me/up/<ref>`"

You can supply any ref that github serves as a tarball. Some common ones:

- `stable` is the latest stable version. I update stable when I bump the version number, and it always fast-forwards (usually to `master`'s HEAD at the time).
- `master` is the development tip. I work on master locally, merging topic branches into it, and push to origin when the specs are green. Its tip is always a descendant of the current `stable` tip.


## gem or it didn't happen

Even though babushka is a ruby app, there's no gem distribution. The reason for this is that setting up a particular ruby build, rubygems, and maybe rvm or rbenv along the way is just the kind of thing babushka is good at. So in the interests of consistency, there's just one install method, which requires only `curl`.


## Dependencies

Babushka itself has just one extra requirement alongside `ruby` and `curl`, which is `git`. The install process takes care of installing git on your system if you don't already have it. On Linux, babushka will use the system's package manager; on OS X, the binary package from git-scm.com (otherwise installing babushka would require Xcode).

The bootstrapper is pretty simple. All it does is install ruby and git as required (using the system's package manager; recent OS X systems already have both installed), download a tarball of babushka, and run `babushka babushka`, which kicks off a built-in recipe that installs babushka for real. Meta, eh?

If you'd prefer to install manually or just check out the code, check [the github page](http://github.com/benhoskings/babushka) for the repo URL.
