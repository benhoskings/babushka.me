---
layout: "/_layout.html.haml"
title: Running babushka
---


## Commandline Syntax

Babushka uses the subcommand & options commandline style, similar to `git`, `gem` and `bundle`. To see the commands available:

    $ babushka help

For more details on options and arguments, check the help output for a specific subcommand:

    $ babushka help meet

You can abbreviate subcommands as long as they remain unique; at present, each one can be abbreviated to a single letter without any ambiguity.


## Running deps

To run deps, use the "meet" subcommand, passing the dep names you're after as arguments. But "meet" is also the default subcommand, so the best way to run deps is to just pass them as arguments, straight up. For example, to run the built-in "rubygems" dep:

    $ babushka rubygems

Note that this doesn't mean "install rubygems"; that's too imperative and not [how deps work](http://babushka.me/how-deps-work). Instead, it means "check whether rubygems is up-to-date, installing or updating as required". It's the goal, not the action that gets you there, that's important. For more info, check the section on [running deps](/running-deps).

If something isn't working, you have a list of things that _aren't_ the culprit: everything in the output with a green ✓ beside it. Conversely, if babushka can detect the problem, the failing dep will have a red ✗ beside it instead, which leads you straight to the cause of the problem. Test-driven sysadmin!


## The babushka console

Although babushka is predominantly a commandline app, it's not implemented that way. All the commandline functionality is available at a ruby console too:

    $ babushka console

To properly recreate the runtime environment, mix in the babushka DSL:

    >> include Babushka::DSL

Here are some brief examples for using the console. To meet a dep:

    >> Dep('rubygems').meet

To check if a dep is met (i.e. what `--dry-run` does):

    >> Dep('homebrew').met?

To run shell commands using babushka:

    >> include Babushka::ShellHelpers
    >> shell './configure', '--prefix=/usr/local', log: true

To run basic git operations:

    >> repo = Babushka::GitRepo.new('/some/path')
    >> repo.branches.include?('topic')


## Using babushka as a library

All the babushka console does is start an irb session, requiring 'lib/babushka'. Hence, everything will work as expected if you require 'lib/babushka' in a program of your own and then use babushka programatically.

The top-level methods like `dep` and `meta` won't be included by default; you can `include Babushka::DSL` to add them to whatever scope you like.

The only caveat to be aware of is that babushka does monkey-patch some convenience methods onto core classes, like `Array#collapse` and `String#p`. If babushka's primary use was as a library then I wouldn't be patching in this way, but I think it's a worthwhile tradeoff for the concise deps that the patches allow you to write.


## Logs

As was mentioned above, the `--debug` option causes babushka to print more verbose information as it runs. Shell commands will print their full output as they run, and babushka will print details about its own operation -- for example, it will print a message as it lazily defines each dep.

If an exception is raised, then by default, babushka prints the exception message, and the step in the backtrace that occurred within your dep, if any. When `--debug` is passed, though, babushka prints the full backtrace.

All this information is too verbose to print all the time, so you'll probably only want to use `--debug` when you're troubleshooting a dep, or hacking on babushka itself. But sometimes it's useful to look at debugging information after the fact, and so babushka always writes the full debug log to `~/.babushka/logs/<dep name>` -- whether `--debug` was passed or not.

You can start viewing the debugging information for a run that's already in progress too, since babushka writes to the log in realtime. If you've started a babushka run, or would like to troubleshoot a long-running process or similar, just follow its debug log with `tail`:

    $ tail -f ~/.babushka/logs/<dep name>

You'll see the full debug log echoed to the terminal as babushka writes it -- just as if you'd originally run babushka with `--debug`.
