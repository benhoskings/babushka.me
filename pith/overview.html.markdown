---
layout: "/_layout.html.erb"
title: Overview
---


When you spend time researching something new, it's pretty easy to forget what you found. That means next time, you have to re-research it again.

A lot of the tech jobs we do manually aren't challenging or fun, but they're quite particular and have to be done just right -- they're chores. Things that are important to do, but that are better automated than done manually.

That's what babushka is for. Once you describe a job using its DSL, babushka can not only accomplish each part of the job, but also check if each part is already satisfied. For each component of the job, a test, along with the code to make that test pass -- test-driven sysadmin.


## Sounds lofty.

I promise it isn't. The idea is to write little snippets of ruby that do those jobs you can never remember exactly off the cuff.

    dep 'public key' do
      met? { grep /^ssh-dss/, '~/.ssh/id_dsa.pub' }
      meet { log_shell "Generating a new key", "ssh-keygen -t dsa -f ~/.ssh/id_dsa -N ''" }
    end

That little chunk of ruby lets you do this:

    ⚡ babushka 'public key'
    public key {
      meet {
        Generating a new key... done.
      }
    } ✓ public key


Babushka starts with `met?`, which in this case returned something falsey -- a failing test. Next, it called `meet`, which generated a new key, throwing away the return value. And now `met?` returns true-ish, which means that running `meet` made the failing `met?` test pass. Success!

If we run it a second time, we see this:

    ⚡ babushka 'public key'
    public key {
    } ✓ public key

Babushka starts with the `met?` test like the first time, but since it's already passing now, there's nothing to do.


## Self-documenting code

Deps are written in a declarative style, which makes them a good reference too. Reading over the `'public key'` dep above, you check if you have a public key by inspecting `~/.ssh/id_dsa.pub`, and you generate a new one by running `ssh-keygen` with a certain set of options.


## Design priorities

I've tried hard to focus on the idea of "no job too small", keeping things lo-fi and trusting the power of unix and git to solve problems for me where it makes sense.


## And, yeah...

It's true, babushka means "grandmother" in Russian. The thing is, here in Australia, "babushka doll" is the colloquial term for Russian nesting dolls. Deps are intended to be small, tidy chunks of code, nested within each other - hence the name.
