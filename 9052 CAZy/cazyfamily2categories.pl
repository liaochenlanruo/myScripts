#!/usr/bin/perl
use strict;
use warnings;

my %category;
my %hash;
my @samples;
my $count = 0;
open IN, "CAZy.Matrix.txt" || die;
while (<IN>) {
	$count++;
	chomp;
	if ($count == 1) {
		@samples = split;
	}else {
		my @lines = split;
		$lines[0]=~/(.+?)\d+/;
		my $cate = $1;
		$category{$cate}++;
		for (my $i=0; $i<@samples; $i++) {
			my $j = $i + 1;
			$hash{$samples[$i]}{$cate} += $lines[$j];
		}
	}
}
close IN;


open OUT, ">CAZy.Category.Matrix.txt" || die;

my @category = sort keys %category;

print OUT "\t" . join("\t", @samples) . "\n";
for (my $i=0; $i<@category ;$i++) {
	print OUT $category[$i];
	for (my $j=0; $j<@samples ;$j++) {
		if (exists $hash{$samples[$j]}{$category[$i]}) {
			print OUT "\t$hash{$samples[$j]}{$category[$i]}";
		}else {
			print OUT "\t0";
		}
	}
	print OUT "\n";
}
close OUT;
