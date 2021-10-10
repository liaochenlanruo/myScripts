#!/usr/bin/perl
use strict;
use warnings;

my @cazy = glob("*.CAZy.diamond");
foreach  (@cazy) {
	$_=~/(.+).CAZy.diamond/;
	my $out = $1 . ".CAZy.diamond.filtered";
	open IN, "$_" || die;
	open OUT, ">$out" || die;
	while (<IN>) {
		chomp;
		$_=~s/[\r\n]+//g;
		my @lines = split /\t/;
		if ($lines[2] >= 40) {# ±£Áôidentity >= 40% µÄÐÐ
			print OUT $_ . "\n";
		}
	}
	close IN;
	close OUT;
}
