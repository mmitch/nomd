#!/usr/bin/perl
use strict;
use warnings;
use v5.10;

use List::Util qw(max);

my $longest_cmd = 20;

#################################

sub scanfile($)
{
    my ($file) = @_;
    my @docs;
    
    open SCAN, '<', $file or die "can't open `$file': $!";

    my $current = {};
    
    while (my $line = <SCAN>) {
	if ($line =~ /^([a-z][a-z_]+)\(\)/) {
	    push @docs, $current if exists $current->{DESC};
	    $current = { NAME => $1 };
	}
	elsif ($line =~ /^##([A-Z]{8})\s+(.*)$/) {
	    my ($key, $data) = ($1, $2);
	    if ($key eq 'CHECKDSC' or $key eq 'NOTYDESC') {
		if (exists $current->{DESC}) {
		    $current->{DESC} .= "\n";
		} else {
		    $current->{DESC} = '';
		}    
		$current->{DESC} .= $data;
	    }
	}
    }
    push @docs, $current if exists $current->{DESC};
    
    close SCAN or die "can't close `$file': $!";

    return @docs;
}

sub print_short($)
{
    my ($doc) = @_;

    my $cmd = $doc->{NAME};

    my $tagline = $doc->{DESC} // '/no description/';
    chomp $tagline;
    $tagline =~ s/\n.*/[…]/s;

    printf "%-${longest_cmd}s  %s\n", $cmd, $tagline;
}

#################################

my @files = @ARGV;

my @docs = sort { $a->{NAME} cmp $b->{NAME} } map { scanfile($_) } @files;
$longest_cmd = max map { length $_->{NAME} } @docs;

print_short($_) foreach @docs;
