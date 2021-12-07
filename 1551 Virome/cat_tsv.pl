#!/usr/bin/perl
use strict;
use warnings;

my %hash;
my $head_checkv;
my $head_pass1;
my $count = 0;
my $num = 0;
open IN, "checkv/contamination.tsv" || die;
while (<IN>) {
	chomp;
	$_ =~s/[\r\n]+//g;
	$count++;
	if ($count == 1) {
		$head_checkv = $_;
	}else {
		my @lines = split /\t/;
		$hash{$lines[0]} = $_;
	}
}
close IN;

open IN, "vs2-pass1/final-viral-score.tsv" || die;
open OUT, ">forCheck.txt" || die;
while (<IN>) {
	chomp;
	$_ =~s/[\r\n]+//g;
	$num++;
	if ($num == 1) {
		$head_pass1 = $_;
		print OUT "$head_pass1\t$head_checkv\n";
	}else {
		my @line = split /\t/;
		if (exists $hash{$line[0]}) {
			print OUT "$_\t$hash{$line[0]}\n";
		}else {
			print OUT "$_\n";
		}
	}
}
close IN;
close OUT;
