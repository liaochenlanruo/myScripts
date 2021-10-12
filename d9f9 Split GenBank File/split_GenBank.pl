#!/usr/bin/perl
use strict;
use warnings;
# Author: Liu hualin
# Date: Oct 9, 2021

my @gbk = glob("*.gbk");# ���������к�׺Ϊ.gbk���ļ�
foreach  (@gbk) {
	$_=~/(.+).gbk/;
	my $str = $1;
	open IN, "$_" || die;
	local $/ = "LOCUS";
	<IN>;
	while (<IN>) {
		chomp;
		$_=~/\s+(\S+)/;
		my $scaf = $1;
		my $out = $str . "_" . $scaf . ".gb";
		my $assession = $str . "_" . $scaf;
		$_=~s/ACCESSION.+/ACCESSION   $assession/g;# ���ACCESSION number
		open OUT, ">$out" || die;
		print OUT "LOCUS$_";
		close OUT;
	}
	close IN;
}
