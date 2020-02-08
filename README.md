nomd nomitoring distribution
============================

[![Build Status](https://travis-ci.org/mmitch/nomd.svg?branch=master)](https://travis-ci.org/mmitch/nomd)
[![GPL 3+](https://img.shields.io/badge/license-GPL%203%2B-blue.svg)](http://www.gnu.org/licenses/gpl-3.0-standalone.html)

Generally, nomd is small and lightweight nomitoring distribution.  
Specifically, nomd is no omd.

nomd is designed to be run once or twice a day via cron or every time
you log in to your desktop.  It can inform and warn you about various
things, like that one partition that is nearly full again or that your
ISP mail server is currently unreachable.

nomd is not designed to be deployed on a server farm with hundreds of
systems and provide instant alerts, graphs and statistics.  There are
various other tools for this kind of scenario (but if you do look for
a small and simple solution for some local statistic graphs, have a
look at https://github.com/mmitch/rrd).

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
* no special privileges required
  - all default command should run as a normal user, no root needed

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

If you use the `pkg` package manager, `./nomdep --pkg` tries to guess
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
  script, you can mostly do what you want, but you should not write to
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

To get started with your own configuration, copy `check.default` and
`notify.default` to `check.local` and `notify.local` and start
hacking.

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

running nomd
------------

To start nomd, you must change into the installation directory and run
`./nomd`.  Alternatively, you can run `make` or `make run`, but this
does not allow you to pass parameters to your scripts.

nomd runs the configured *checks*, sends any *notifications* and
exits.

### irregular runs

On desktop systems a good way to run nomd would be on every logon.
Depending in your system configuration, it could suffice to add this
line to your `~/.xinitrc`:

```
( cd git/nomd; ./nomd ) &
```

This will run nomd in the background so your login does not stall.  It
expects the nomd installation directory to be `$HOME/git/nomd`.

### regular runs

Use a tool of your choice to run nomd regularly if your system is
running continuously.

If you use cron, the following crontab entry would run nomd twice a
day if your installation directory is `$HOME/git/nomd`:

```
0 5,17	* * *	cd git/nomd; ./nomd
```

updates
-------

If you cloned the nomd repository, simply run `git pull` to get the
latest changes.  You can use the `check_nomd_updates` *check* to get
informed when updates are available.

resources
---------

Project homepage, git repository and bug tracker are available at
https://github.com/mmitch/nomd

license
-------

Copyright (C) 2017, 2018, 2019, 2020  Christian Garbs <mitch@cgarbs.de>  
Licensed under GNU GPL v3 or later.

nomd is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

nomd is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with nomd.  If not, see <http://www.gnu.org/licenses/>.
