#!/usr/bin/perl
use strict;
use warnings;

my $count = 0;
open IN, "forCheck.txt" || die;
open VIRUS, ">Virus.txt" || die;
open MANUAL, ">Manual_check.txt" || die;
open DISCARD, ">Discard.txt" || die;
while (<IN>) {
	chomp;
	$_ =~s/[\r\n]+//g;
	$count++;
	if ($count == 1) {
		print VIRUS $_ . "\n";
		print MANUAL $_ . "\n";
		print DISCARD $_ . "\n";
	}else {
		my @lines = split /\t/;
		if ($lines[15] > 0) { # virus keep1
			print VIRUS $_ . "\n";
		}elsif (($lines[15] == 0) && ($lines[16] == 0)) { # virus keep2
			print VIRUS $_ . "\n";
		}elsif (($lines[15] == 0) && ($lines[6] >= 0.95)) { # virus keep2
			print VIRUS $_ . "\n";
		}elsif (($lines[15] == 0) && ($lines[9] > 2)) { # virus keep2
			print VIRUS $_ . "\n";
		}elsif (($lines[15] == 0) && ($lines[16] == 1) && ($lines[8] >= 10000)) { # manual check
			print MANUAL $_ . "\n";
		}else { # discard
			print DISCARD $_ . "\n";
		}
	}
}
close IN;
close VIRUS;
close MANUAL;
close DISCARD;
