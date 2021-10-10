#!/usr/bin/perl
use strict;
use warnings;


my %cazy;

open IN, "cazy_data.txt" || die;
while (<IN>) {
	chomp;
	my @lines = split /\t/;
	$cazy{$lines[2]} = $lines[0];
}
close IN;


my %hash;
my %samples;
my %ids;
my @filtered = glob("*.CAZy.diamond.filtered");
foreach  (@filtered) {
	$_=~/(.+).CAZy.diamond.filtered/;
	my $sample = $1;
	$samples{$1}++;
	open IN, "$_" || die;
	while (<IN>) {
		chomp;
		my @line = split /\t/;
		if (exists $cazy{$line[1]}) {
			$ids{$cazy{$line[1]}}++;
			$hash{$sample}{$cazy{$line[1]}}++;
		}
	}
	close IN;
}

open OUT, ">CAZy.Matrix.txt" || die;

my @samples = sort keys %samples;
my @ids = sort keys %ids;

print OUT "\t" . join("\t", @samples) . "\n";
for (my $i=0; $i<@ids ;$i++) {
	print OUT $ids[$i];
	for (my $j=0; $j<@samples ;$j++) {
		if (exists $hash{$samples[$j]}{$ids[$i]}) {
			print OUT "\t$hash{$samples[$j]}{$ids[$i]}";
		}else {
			print OUT "\t0";
		}
	}
	print OUT "\n";
}
close OUT;
