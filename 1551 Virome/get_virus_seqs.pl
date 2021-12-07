#!/usr/bin/perl
use strict;
use warnings;

my %hash;
open IN, "checkv/combined.fna" || die;
local $/ = ">";
<IN>;
while (<IN>) {
	chomp;
	my ($header, $seq) = split(/\n/, $_, 2);
	my $id;
	if ($header =~/(\S+)\|\|.+/) {
		$id = $1;
	}else {
		$id = $header;
	}
	$hash{$id} = $seq;
}
close IN;

local $/ = "\n";
open IN, "Virus.txt" || die;
open OUT, ">Virus.fas" || die;
open NO, ">NoSeqs.ids" || die;
<IN>;

while (<IN>) {
	chomp;
	my @lines = split /\t/;
	$lines[0] =~/(\S+)\|\|/;
	if (exists $hash{$1}) {
		print OUT ">$lines[0]\n$hash{$1}\n";
	}else {
		print NO "$lines[0]\n";
	}
}
close IN;
close OUT;
close NO;
