#!/usr/bin/perl
use strict;
use warnings;
# Author: Liu Hualin
# Date: 2022.01.08
# Name: Run_deepARG_reads.pl

my @scafs = glob("*.fna"); #双引号中的为路径和双端测序中前端Reads文件的后缀名,参考“F02_clean.R1.fq.gz”
foreach  (@scafs) {
	$_=~/(.+).fna/;
#	my $name = $1;
	my $out = $1 . ".arg";
	system("deeparg predict --model LS --type nucl --input $_ --out $out -d ~/tools/deeparg/");
}
