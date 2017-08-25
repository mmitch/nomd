nomd
====

Generally, nomd is a simple nomitoring distribution.  
Specifically, nomd is no omd.

nomd is a small and lightweight monitoring distribution that is
intended to run on a single system.  It is designed to be run once or
twice a day via cron or every time you log in to your desktop.  It can
inform and warn you about various things, like that one partition that
is nearly full again or that your ISP mail server is currently
unreachable.

nomd is not designed to be deployed on a server farm with hundreds of
systems and provide instant alerts, graphs and statistics.  There are
various other tools for this kind of scenario (but see ^footnote in
the resources chapter below).

features
--------

* very few dependencies
  - some usual shell commands
  - some Perl
* easy to install
  - clone the git repository and you're ready to go
  - run on demand or via cron
* simple configuration
  - it's just a shell script, no need to learn a new language
* maximum flexibility
  - configuration is just a shell script: use conditions, call
	external tools, everything is possible
* self documenting
  - `nomdoc` shows all available commands and explains their use
  - `nomdep` shows missing dependencies (binaries, Perl modules)

quick start
-----------

After cloning the repository, enter the `nomd` directory and run
`./nomd` to run the default configuration.  If you run into problems
or like to know more, read on.

basics
------

Note: All nomd operations expect your current working directory to be
the root directory of the nomd installation.

nomd basically distinguishes two types of commands:

* *checks* are commands that execute various checks and return the
  status as a result

* *notifications* are commands that aggregate the generated status and
present them to you in different ways

dependencies
------------

nomd definitely needs

* bash 4 or later
* Perl 5.10 or later

All other dependencies can be listed by running `./nomdep`.  It will
show missing dependencies together with the checks and notifications
that depend on them so you can decide if you need that dependency or
can live on without it.

Installing missing dependencies is up to you.

If you use the `apt` package manager, `./nomdep --apt` tries to guess
missing package names for you.  This is quite wobbly, but might save
you some searching and typing in simple cases.

If you manage local Perl packages via `cpanm`, run `./nomdep --cpanm`
to print a command to install all missing Perl packages at once.  The
output should be usable for other Perl package managers, too.

documentation
-------------

Run `./nomdoc` to show a list of all available *checks* and
*notifications*.

Add an argument to show details about all *checks* and *notifications*
that match the given argument (it's treated as a regular expression).
`./nomdoc ^notify` will list all *notifications* with their
parameters.

configuration
-------------

`nomd` reads these configuration files:

* `check.local` contains the *checks* you want to run.  It is a shell
  script, you can mostly do what you want, but you should not write do
  stdout as this is where the check results are collected.
* If `check.local` is missing, `nomd` falls back to `check.default`
  which contains an example configuration and is part of the nomd
  distribution.
* Likewise, `notify.local` contains the *notifications* you want to
  run.  It is also shell script, but this time stdout can be used
  without restrictions.
* Again, if `notify.local` is missing, `nomd` falls back to
  `notify.default` which contains an example configuration and is part
  of the nomd distribution.

To get started with your own configuration, copy
`check.default`/`notify.default` to `check.local`/`notify.local` and
start hacking.

Both `check.local` and `notify.local` are not part of the git
repository and will not be overwritten on updates.

### advanced configuration

`nomd` currently passes all arguments to both the check and notify
scripts.  I often do something like this in my `notify.local` to allow
quick testing of changes via `./nomd --test` when `nomd` is normally
just run daily via cron:

```shell
if [ "$1" = '--test' ]; then
    notify_stdout
else
    notify_mail
fi
```

### custom checks and notifications

Have a look at the existing *checks* and *notifications* in the
`check/` and `notify/` subdirectories and/or read `PROTOCOL.md` for a
quick overview of some of the internals.

You can implement custom commands either directly in your
`check.local`/`notify.local` or write a standalone command in the
`check/` and `notify/` subdirectories.

If your standalone custom commands might be useful for other people,
feel free to send me a pull request so they can be included in the
nomd distribution :-)

updates
-------

If you cloned the nomd repository, simply run `git pull` to get the
latest changes.  You can use the `check_nomd_updates` *check* to get
informed when updates are available.

resources
---------

Project homepage, git repository and bug tracker are available at
https://github.com/mmitch/nomd

^footnote  
If you are by any chance looking for small and lightweight graph
statistics for a single system, have a look at nomd's big sister
project at https://github.com/mmitch/rrd (yes, the README is still
missing over there)
