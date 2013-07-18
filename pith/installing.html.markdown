---
layout: "/_layout.html.haml"
title: Installing babushka
---

Babushka is best installed using `babushka.me/up`, a script that installs babushka via git (and some dependencies via your system's package manager). It's safe to run on existing systems; if you're running git and ruby already then all that's installed is babushka itself.

The script is also designed to be used as the initial shell command on a brand new laptop or server. Its only prerequisite, which most systems ship with, is something that can fetch over https. Mac OS X and some Linux distros ship with `curl`:

    sh -c "`curl https://babushka.me/up`"

If your system doesn't ship with curl, you can install it first. Here are some examples:

    # on Arch Linux
    pacman -S curl && sh -c "`curl https://babushka.me/up`"

    # on Ubuntu Linux
    apt-get install -y curl && sh -c "`curl https://babushka.me/up`"

Some other Linux distros ship with `wget` instead. Many of these stock wget installs lack openssl, which means no https downloads. You could install curl first (which should pull in openssl; see above), or just cowboy it over http with wget:

    sh -c "`wget -O - babushka.me/up`" # Hijack me, please!


## What it does

The script is fairly straightforward. Here's what it does:

- Installs ruby & curl via your package manager, as required
- Downloads a tarball of babushka from github
- Runs `babushka babushka` to do the actual install (meta, eh?), which:
  - Installs git via your package manager, as required
    - On OS X, the binary package from http://git-scm.com is used instead, otherwise installing babushka would require Xcode.
  - Clones the babushka repo to `/usr/local/babushka`, or whatever you choose
  - Symlinks the executable to `/usr/local/bin`

Here's [the script](https://babushka.me/up) and [the template](https://github.com/benhoskings/babushka.me/blob/master/app/views/bootstrap/up.sh.erb) that it's rendered from if you'd like to review them.

Installing babushka doesn't make any surprising changes to your system. You can completely uninstall it by deleting it:

    rm -rf /usr/local/babushka /usr/local/bin/babushka


## Scripting the install

The bootstrap script prompts for confirmation and an install prefix. If you're scripting the install, fear not: it runs unconditionally, accepting the defaults for those prompts, if STDIN isn't attached to a terminal. If you'd like to run a prompt-less install at the terminal, just attach `STDIN` to `/dev/null` instead:

    sh -c "`curl https://babushka.me/up`" </dev/null


## Versions

By default, `babushka.me/up` will install the latest stable version, but this can be customised. Just pass a git ref to the script like so (the default is `stable`):

    sh -c "`curl https://babushka.me/up/<ref>`"

You can supply any ref that github serves as a tarball: any branch, tag, or SHA will work. Some examples:

- `stable` is the latest stable version. I update stable when I tag a new version, and it always fast-forwards (usually to `master`'s HEAD at the time).
- `master` is the development tip. I work on master locally, merging topic branches into it, and push to github when the specs are green. Its HEAD is always a descendant of the current `stable` HEAD.

If you like, you can lock your install by supplying a SHA, which can never change:

    sh -c "`curl https://babushka.me/up/4ff73e0eda5ff439fd786e4a3bea8568abc95fe2`"

You could also use a tag, for readability (I promise I'll never change a version tag):

    sh -c "`curl https://babushka.me/up/v0.16.10`"


## Installing a custom babushka

By default, babushka is installed from my repo on github, [benhoskings/babushka](https://github.com/benhoskings/babushka). If you like, you can install from your own repo instead by passing a custom repo URI in the `$BABUSHKA_REPO` envorinment variable, like so:

    BABUSHKA_REPO=https://github.com/dgoodlad/babushka.git \
      sh -c "`curl https://babushka.me/up/master`"

This is useful for running installs in situations where github isn't accessible, or if you'd like to install from a fork of babushka.


## Manual installation

If you'd prefer to install manually, it's pretty straightforward. First, ensure ruby and git are installed to your taste:

    pacman -S ruby git # Adjust for your system as required

Grab a local copy of babushka from [the githubs](https://github.com/benhoskings/babushka):

    git clone https://github.com/benhoskings/babushka.git ./babushka
    cd babushka

Then you can run babushka with `./bin/babushka.rb`, or if you like, symlink it into your PATH:

    cd /usr/local/bin
    ln -s /path/to/babushka/bin/babushka.rb ./babushka


## My kingdom for a gem

Even though babushka is a ruby app, there's no gem distribution. The reason for this is that setting up a particular ruby build, rubygems, and maybe rbenv or chruby along the way is just the kind of thing babushka is good at. So in the interests of consistency, I recommend installing babushka via git repo every time, whether or not you use `babushka.me/up` to do it.
