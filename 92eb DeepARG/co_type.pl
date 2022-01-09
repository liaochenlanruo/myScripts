#!/usr/bin/perl
use strict;
use warnings;
# Author: Liu Hualin
# Date: 2022.01.09
# Name: co_type.pl

my (%hash, %genome, %gene);
my @type = glob("*.ARG.merged.quant.type");
foreach  (@type) {
	$_=~/(\S+?)\..+/;
	my $str = $1;
	$genome{$str}++;
	open IN, "$_" || die;
	<IN>;
	while (<IN>) {
		chomp;
		my @lines = split /\t/;
		$gene{$lines[0]}++;
		$hash{$str}{$lines[0]} = $lines[2];
	}
	close IN;
}


my @str = sort keys %genome;
my @arg = sort keys %gene;
open OUT, ">All.ARGs.txt" || die;
print OUT "\t";
print OUT join("\t", @arg);
print OUT "\n";
for (my $i=0; $i<@str; $i++) {
	print OUT $str[$i];
	for (my $j=0; $j<@arg; $j++) {
		if (exists $hash{$str[$i]}{$arg[$j]}) {
			print OUT "\t$hash{$str[$i]}{$arg[$j]}";
		}else {
			print OUT "\t0";
		}
	}
	print OUT "\n";
}
close OUT;