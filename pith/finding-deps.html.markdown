---
layout: "/_layout.html.haml"
title: Finding deps
---

You can search on github for deps you might like to use, using the term 'babushka-deps'.


## Trust

Deps can run any ruby code. Since ruby can shell out, a dep can run any code at all. A maliciously written dep could add your machine to a botnet, or email your ssh key to a mobster, or anything crafty or untoward you can think of.

(This is true of any code you run on your machine. If you run it, you're trusting it.)

Babushka has no security features at all. This is by design, because the only real type of security is a network of trust. Anything else is, [as Linus Torvalds said](http://www.youtube.com/watch?v=4XpnKHJAok8#t=27m36s), masturbation.

The upshot: Only run deps written by people you trust to get them right, or deps whose code you've inspected beforehand.

In particular, `--dry-run` is not a contract; it's an honour system. A badly written dep could still change your system even when you use `--dry-run`.

Dep sources are shared using git, so you can rely on their immutability once you've checked the refs, like any git repo.


## Dep Locations

There are three standard locations that babushka will search within to find deps.

- The core deps that are bundled with babushka are found at `/usr/local/babushka/deps` (or within the `deps/` directory of your custom install path, if you used one). This is a fixed set of deps; they're the bare minimum required to install babushka itself, along with its dependencies like git, and to check for system stuff like package managers. This source is called `core`.

- You can put your own personal deps in `~/.babushka/deps`. Babushka will load that path as the a source called `personal`, so the deps within that directory will always be available. There's no need to, but I recommend you make `~/.babushka/deps` a git repo. It's a good idea to use git to manage your personal deps, and if you like, you can push them to github for others to use. (Mine are [here](http://github.com/benhoskings/babushka-deps).)

- The `./babushka-deps/` directory, i.e. within the current directory, will also be loaded as a source, named `current dir`. This is a good place to put project-specific deps -- whenever you're in the project's root directory (in the root of a rails project, for example), babushka will make the deps within `babushka-deps/` available.

Babushka will find deps in those locations by default. Other deps -- ones published by other people, for example -- are found in [dep sources](/dep-sources).

