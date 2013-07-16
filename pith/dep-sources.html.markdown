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

If you'd like to use a source that doesn't follow the above convention, then you can add it yourself, specifying a custom name:

    $ babushka sources --add custom git://example.org/a/custom/dep-source.git

That command will clone `git://example.org/a/custom/dep-source.git` to `~/.babushka/sources/custom`.

This system is configuration-free apart from the repos themselves: the source names are the directory names, and the URLs are the locations of the corresponding 'origin' git remotes. Hence, you can add sources manually, or make them available in a base VM image, etc, by placing the repo in `~/.babushka/sources` yourself:

    cd ~/.babushka/sources
    git clone git://example.org/a/custom/dep-source.git ./custom

Instead of cloning directly into `~/.babushka/sources`, you can symlink to other paths instead, and babushka will follow the symlinks when searching for sources.

You can name the git repos within `~/.babushka/sources` however you like, and then use those names whenever you reference deps. It's only when a named source isn't present already that the github URI convention is used.

When `--update` is passed, babushka will update the sources from 'origin/master' before using them. As with the repo names, you can use any URI you like for the 'origin' remote, including private ones for which you have credentials, and babushka will follow your lead. It's only when automatically cloning that the convention is used to set the URI.
