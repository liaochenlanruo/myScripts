#!/usr/bin/perl
use strict;
use warnings;
# Author: Liu Hualin
# Date: 2022.01.08
# Name: Run_deepARG_reads.pl

my @reads = glob("Reads/*.R1.fq.gz"); #双引号中的为路径和双端测序中前端Reads文件的后缀名,参考“F02_clean.R1.fq.gz”
foreach  (@reads) {
	$_=~/(.+).R1.fq.gz/;
	my $reads1 = $_;
	my $reads2 = $1 . ".R2.fq.gz"; #匹配反向Reads文件
	my $out = $1;
	system("deeparg short_reads_pipeline --forward_pe_file $reads1 --reverse_pe_file $reads2 --output_file $out -d ~/tools/deeparg/");
}
