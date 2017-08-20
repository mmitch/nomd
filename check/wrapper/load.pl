#!/usr/bin/perl
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
