#!/usr/bin/perl
#
# Copyright (C) 2017  Christian Garbs <mitch@cgarbs.de>
# Licensed under GNU GPL v3 or later.
#
# This file is part of nomd.
#
# nomd is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# nomd is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with nomd.  If not, see <http://www.gnu.org/licenses/>.
#

use strict;
use warnings;

use v5.10;

my ($crit, $warn) = (@ARGV);

my $line = <STDIN>;

if ($line =~ /\s([0-9.]+)$/) {
    my $load = $1;
    if ($load >= $crit) {
	say "C:load:$load higher than $crit (crit)";
    }
    elsif ($load >= $warn) {
	say "W:load:$load higher than $warn (warn)";
    }
    else {
	say "I:load:$load";
    }
}
else {
    say "C:load:internal error, no parseable input";
}
