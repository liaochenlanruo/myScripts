#!/usr/bin/perl
use strict;
use warnings;
# name: print_pI.pl
# Author: Liu Hualin
# Date: 2022.01.03

my @genome = glob("*.faa");
foreach  (@genome) {
	$_=~/(\S+).faa/;
	my $out = $1 . ".pepstats";
	my $pi = $1 . ".pI";
	system("pepstats -sequence $_ -outfile $out");

	my %hash;
	my $seqnum = 0;
	open IN, "$out" || die;
	while (<IN>) {
		chomp;
		if (/^(Isoelectric Point = )(\S+)/) {
			my $pi = sprintf "%.1f", $2;
			$hash{$pi}++;
			$seqnum++;
		}
	}
	close IN;

	#my @records = values %hash;
	#my $seqnum = @records;
	#print $seqnum . "\n";
	open OUT, ">$pi" || die;
	print OUT "Isoelectric point\tRelative frequency\n";
	foreach  (keys %hash) {
		my $frequency = sprintf "%.2f", $hash{$_}/$seqnum;#@records;
		print OUT "$_\t$frequency\n";
	}
	close OUT;
}