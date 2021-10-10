#!/usr/bin/perl
use strict;
use warnings;

my @mapped = glob("*.mapped");
foreach  (@mapped) {
	$_=~/(.+).mapped/;
	open IN, "$_" || die;
	my $out = $1 . ".GO";
	open OUT, ">$out" || die;
	<IN>;
	while (<IN>) {
		chomp;
		$_=~s/[\r\n]+//g;
		my @lines = split /\t/;
		print OUT $lines[0];
		if ($lines[18]=~/.+\; /) {
			my @terms = split /\; /, $lines[18];# 18代表文件的第19列
			print OUT "\t" . join("\t", @terms) . "\n";
		}elsif ($lines[18]=~/\S+/) {
			print OUT "\t" . $lines[18] . "\n";
		}else {
			print OUT "\n";
		}
	}
	close IN;
	close OUT;
}
