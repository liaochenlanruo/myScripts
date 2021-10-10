#!/usr/bin/perl
use strict;
use warnings;

local $/=">";
open IN, "All.sequences.fas" || die;
open OUT, ">CAZy.fas" || die;
<IN>;
while (<IN>) {
	chomp;
	print OUT ">$_\n";
}
close IN;
close OUT;
