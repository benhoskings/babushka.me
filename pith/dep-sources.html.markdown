---
layout: "/_layout.html.haml"
title: Dep sources
---

Babushka only contains the deps that it needs to know how to install itself, and set up a bare minimum of software like package managers, `ruby` and `git`. Everything else is stored separately, in _dep sources_.

A dep source is just a git repo, with some deps in it. The organisation and naming of the files within the source is completely up to you - babushka will recursively load all the `.rb` files it can find in the source, in alphabetical order.

You also don't need to worry about dep or template load order; source loading is a lazy process that first reads every file and sets up the templates, and doesn't define deps until later, as they're run.

As a convention, I tend to keep related deps together in top-level `.rb` files, and use a top-level `templates/` directory for meta deps. But the layout of the files and directories doesn't affect the way babushka makes the deps & templates available, so use whatever convention you like.


## Dep source management

The best way manage your own source is to make `~/.babushka/deps` a git repo, and push it to `https://github.com/username/babushka-deps.git`. That will allow you to run your deps like so, on any machine, and for others to do the same:

    $ babushka username:dep-name


## Local sources

If you want to write deps just for yourself that you don't plan to share, `~/.babushka/deps` is still the best place for them; just make the repo private if you do push it online. If you'd rather keep them elsewhere, like in `~/src` or similar, you can symlink them into `~/.babushka/deps` instead.

Babushka also loads deps from `./babushka-deps` in the directory from which it was run. This is a good place for project-specific deps, because you can keep them within the project's source control.


## Using others' sources

To run deps from others' sources, just prefix the dep name with the correct github username, and babushka will clone the source for you.

    babushka conversation:coffeescript.src

If there's no source at `~/.babushka/sources/conversation` then babushka will clone it from `github.com/conversation/babushka-deps`, and then search within it for a dep called "coffeescript.src". (You don't have to worry about naming conflicts with other sources; dep and template names are partitioned per-source.)

There's one exception to this rule: the source name 'common' corresponds not to the github user 'common' (sorry, Common), but to [benhoskings/common-babushka-deps](http://github.com/benhoskings/common-babushka-deps). In that source, I maintain some deps for common tasks useful to all babushka users, like deploying apps via git repo.


## Customising sources

The convention system is only a starting point: you can use it as much or as little as you like. Babushka identifies sources purely by name, and only uses the convention to clone sources that aren't present by name (i.e. when `~/.babushka/sources/<name>` doesn't exist).

When the source does exist by name, then babushka will happily load from it, no matter where it came from. This makes it very easy to add custom sources, or make sources available in a base VM image, etc. All you have to do is place the appropriate repos in `~/.babushka/sources`:

    cd ~/.babushka/sources
    git clone git://example.org/custom-dep-source.git ./custom

That will make a source called 'custom' available, from which you can invoke deps like so:

    babushka custom:'a custom dep'

(You can symlink instead of cloning directly into `~/.babushka/sources`; babushka follows symlinks when loading sources.)

There's also a babushka command you can use to add sources. Internally, all it does it clone the repo; it's there purely as a convenience:

    $ babushka sources --add custom git://example.org/custom-dep-source.git

Running that command will clone `git://example.org/custom-dep-source.git` to `~/.babushka/sources/custom`.

To recap, you can name the git repos within `~/.babushka/sources` however you like, and then use those names whenever you reference deps. It's only when a named source isn't present, and babushka auto-clones it, that its name and URI are set by convention.


## Updating sources

Babushka doesn't automatically update sources. If you push new or breaking changes to your source, you don't need to worry about breaking existing babushka setups; anywhere that source is cloned, it will stay put at its current version and continue to work.

(In the olden days babushka did auto-update sources, but this behaviour caused too many "dammit, this worked yesterday" surprises.)

The only time babushka will change existing sources is when it's run with the `--update` option. With this option specified, babushka will lazily update sources before it loads deps from them. That is, `--update` doesn't update all existing sources, just each relevant source as it's referenced down the tree. (A source is only updated once per run.)

When updating, babushka fetches from 'origin' and then resets the source to 'origin/master'. There's a safety check, though, that will prevent updates if the source has uncommitted changes or unpushed commits, to avoid blowing away your local changes (babushka will print a message in this case).

As with the repo names, you can use any URI you like for the 'origin' remote, including private URIs for which you have credentials, and babushka will follow your lead. It's only when automatically cloning that the github username convention is used to set the URI.
