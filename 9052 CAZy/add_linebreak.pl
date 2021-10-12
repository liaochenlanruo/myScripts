#!/usr/bin/perl
use strict;
use warnings;
# Author: Liu hualin
# Date: Sep 30, 2021

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
