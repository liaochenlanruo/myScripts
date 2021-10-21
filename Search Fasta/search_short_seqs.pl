#!/usr/bin/perl
use strict;
use warnings;
# Author: Liu Hualin
# Date: Oct 20, 2021

local $/ = ">";
open IN, "$ARGV[0]" || die;
open OUT, ">Target_seqs.fa" || die;
my $str = $ARGV[1];
<IN>;
while (<IN>) {
	chomp;
	my ($id, $seq) = split ("\n", $_, 2);
	$seq=~s/[\r\n]+//g;
	if ($seq=~/$str/i) {
		print OUT ">$id\n$seq\n";
	}
}
close IN;
close OUT;
