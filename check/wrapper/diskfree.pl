#!/usr/bin/perl
use strict;
use warnings;

use Filesys::Df;
use Sys::Filesystem;

my @skip;

while (my $line = <STDIN>) {
    chomp $line;
    push @skip, qr($line);
}

MOUNTPOINT: foreach my $mountpoint (Sys::Filesystem->new->mounted_filesystems) {
     
    foreach my $skip (@skip) {
	if ($mountpoint =~ /$skip/) {
	    print "I:diskfree:skipped $mountpoint\n";
	    next MOUNTPOINT;
	}
    }
     
    my $df = df($mountpoint, 1024);
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
    
    printf "%s:diskfree:%s on %s\n", $sev, $status, $mountpoint;
}
