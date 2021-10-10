#!/usr/bin/perl
use strict;
use warnings;

my %hash;
my %ids;
my %samples;

my @files = glob("*.mapped");
foreach  (@files) {
	$_=~/(.+).mapped/;
	my $sample = $1;
	$samples{$1}++;
	open IN, "$_" || die;
	<IN>;# ���Ե�һ�У������һ�в��Ǳ����У��뽫����ע�͵�
	while (<IN>) {
		chomp;
		my @lines = split /\t/;
		if ($lines[18]=~/.+\; /) {
			my @terms = split /\; /, $lines[18];# 18�����ļ��ĵ�19�У�������ȡ�����У����������޸ĸ�����Ϊ���к�-1������Ϊ��һ�д���Ϊ0
			foreach  (@terms) {
				$ids{$_}++;
				$hash{$sample}{$_}++;
			}
		}elsif ($lines[18]=~/\S+/) {
			$ids{$lines[18]}++;
			$hash{$sample}{$lines[18]}++;
		}
	}
}
open OUT, ">Matrix.txt" || die;

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
