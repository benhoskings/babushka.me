---
layout: "/_layout.html.haml"
title: Installing babushka
---

You can install babushka on your system, no matter what state it's in, using `babushka.me/up`. That's a script that knows enough to install ruby if required (babushka's only runtime dependency), and then download a temporary babushka that knows how to do the proper install.

The `babushka.me/up` script is designed to be the first command you can run on a new system. The only prerequisite, which most systems ship with, is something that can fetch over https. Mac OS X and some Linux distros ship with `curl`:

    sh -c "`curl https://babushka.me/up`"

If your system doesn't ship with curl, you can install it first. Here are some examples:

    pacman -S curl && sh -c "`curl https://babushka.me/up`" # on Arch Linux
    apt-get install -y curl && sh -c "`curl https://babushka.me/up`" # on Ubuntu Linux

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

Here's [the script](http://babushka.me/up) and [the template](https://github.com/benhoskings/babushka.me/blob/master/app/views/bootstrap/up.sh.erb) that it's rendered from if you'd like to review them.

Installing babushka doesn't make any surprising changes to your system. You can completely uninstall it by deleting it:

    rm -rf /usr/local/babushka /usr/local/bin/babushka


## Scripting the install

The bootstrap script prompts for confirmation and an install prefix. If you're scripting the install, fear not: it runs unconditionally, accepting the defaults for those prompts, if STDIN isn't attached to a terminal. If you'd like to run a prompt-less install at the terminal, just attach `STDIN` to `/dev/null` instead:

    sh -c "`curl babushka.me/up`" </dev/null


## Versions

You can pass a git ref to `babushka.me/up` to install a different babushka version. The default is `stable`.

    sh -c "`curl babushka.me/up/<ref>`"

You can supply any ref that github serves as a tarball. Some common ones:

- `stable` is the latest stable version. I update stable when I bump the version number, and it always fast-forwards (usually to `master`'s HEAD at the time).
- `master` is the development tip. I work on master locally, merging topic branches into it, and push to origin when the specs are green. Its tip is always a descendant of the current `stable` tip.


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
