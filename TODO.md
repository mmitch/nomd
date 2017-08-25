nomd todo list
==============

As nomd is alrady in a usable state (yay!), this is more of a
backlog-for-boring-rainy-afternoons than a must-have-feature list.

Some things are more of a think-about-it-is-it-really-useful than
yeah-that's-a-good-idea.

Also I have probably already gotten sidetracked by other projects.

checks
------

* check_mk wrapper
  - but it's just data, we need to define thresholds etc.
  - sounds like reimplementing Nagios - don't want
* free memory check
  - but what to check? memory? swap? both?
  - what are reasonable warning/crit thresholds?
* ntpd checker

notifications
-------------

* pseudo-notification that mails `check.local` and `notify.local`
  for backup purposes?
* pushbullet
* HTML nuggets to be included in a status page
  - hey, we don't want to be data-center grade :-)

internals
---------

* convenience function for writing the protocol lines that
  automatically detects the name of the current check
