#!/usr/bin/env perl
#
# Copyright (C) 2017, 2000  Christian Garbs <mitch@cgarbs.de>
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

use Filesys::Df;
use Sys::Filesystem;

my @skip_mounts;

while (my $line = <STDIN>) {
    chomp $line;
    push @skip_mounts, qr($line);
}

FS: foreach my $fs (Sys::Filesystem->new->mounted_filesystems) {

    foreach my $skip_mount (@skip_mounts) {
	if ($fs =~ /$skip_mount/) {
	    print "I:diskfree:skipped $fs by mountpoint\n";
	    next FS;
	}
    }
     
    my $df = df($fs, 1024);
    next unless defined $df;

    my ($warn, $crit, $status) = (0, 0);
    
    my $block_p = $df->{bfree} / $df->{blocks} * 100;
    
    if ($block_p < 2) {
	$crit++;
    }
    elsif ($block_p < 5) {
	$warn++;
    }

    $status = sprintf '%3.0d%% free blocks', $block_p;

    if (exists $df->{files}) {
	my $inode_p = $df->{ffree} / $df->{files} * 100;

	if ($inode_p < 2) {
	    $crit++;
	}
	elsif ($inode_p < 5) {
	    $warn++;
	}

	$status .= sprintf ', %3.0d%% free inodes', $inode_p;
    }

    my $sev;
    if ($crit) {
	$sev = 'C';
    }
    elsif ($warn) {
	$sev = 'W';
    }
    else {
	$sev = 'I';
    }
    
    printf "%s:diskfree:%s on %s\n", $sev, $status, $fs;
}
