#!/usr/bin/perl
use strict;
use warnings;

my @gbk = glob("*.gbk");# 批处理所有后缀为.gbk的文件
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
		$_=~s/ACCESSION.+/ACCESSION   $assession/g;# 添加ACCESSION number
		open OUT, ">$out" || die;
		print OUT "LOCUS$_";
		close OUT;
	}
	close IN;
}
