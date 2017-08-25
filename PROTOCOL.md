nomd protocol description
=========================

checks
------

Every *check* writes one or more lines to stdout in the format

```
SEVERITY:CHECK:INFORMATION
```

where

* `SEVERITY` is one of `C` (critical), `W` (warning) or `I`
  (informational - quite verbose, also used for debugging)
* `CHECK`  is the name of the check that wrote the line
* `INFORMATION` is freetext information about the details of the check

All *checks* should provide sensible default values for their
parameters so it is possible to call them without any parameters.

notifications
-------------

*Notifications* are called with these environment variables set:

* `NOMD_CHECK_RESULTS` os pointing to a file with the complete results of
  the preceding checks
* `NOMD_CRIT_COUNT` holds the number of critical check results
* `NOMD_WARN_COUNT` holds the number of warning check results
* `NOMD_INFO_COUNT` holds the number of informational check results
* `NOMD_HIGHEST_SEVERITY` is either `C`, `W` or `I` depending on the
  worst check result

All *notifications* should provide sensible default values for their
parameters so it is possible to call them without any parameters.

dependencies
------------

`nomdep` parses both Perl and shell scripts:

* Perl `use` lines are picked up automatically
* shell scripts (*checks* and *notifications*) must explicitely
  declare their dependencies by adding one `##SHELLDEP` comment line
  per dependency:
  - `##SHELLDEP xyz` depends on binary `xyz`
  - `##SHELLDEP x y z` depends on any one of `x`, `y` or `z`
    (see `http.check`, which can use either `wget`, `curl` or
    `GET/HEAD` to do HTTP requests)

documentation
-------------

`nomdoc` parses both Perl and shell scripts:

* functions in shell scripts not beginning with an underscore are
  treated as commands
* commands must be followed by one or more comment lines to be recognized
  - `##CHECKDSC` lines describe *check* commands
  - `##NOTYDESC` lines describe *notification* commands
* both command types describe their parameters by the following
  comment types as needed
  - `##PARMNAME` defines a new parameter and binds the following two comment types to this parameter
  - `##PARMDESC` describes the parameter
  - `##PARMDFLT` contains the parameter default
