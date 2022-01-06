#!/usr/bin/perl
use strict;
use warnings;

open OUT, ">F06.pi" || die;
print OUT "MAGs\tIsoelectric point\tRelative frequency\n";
my @pI = glob("F06*.pI");
foreach  (@pI) {
	$_=~/(\S+).pI/;
	my $mag = $1;
	open IN, "$_" || die;
	<IN>;
	while (<IN>) {
		chomp;
		print OUT "$mag\t$_\n";
	}
	close IN;
}
close OUT;