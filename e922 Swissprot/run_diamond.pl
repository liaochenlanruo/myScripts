#!/usr/bin/perl
use strict;
use warnings;
# Author: Liu hualin
# Date: Sep 28, 2021

my @faa = glob("*.faa");# 读取所有后缀为“.faa”的文件，可以自己更改
foreach  (@faa) {
	$_=~/(.+).faa/;
	my $out = $1 . ".diamond";
	# 将/new_data/hualin/db/uniprot_sprot_diamond换成自己的数据库路径; -p表示线程数，在笔记本上用6个即可
	system("diamond blastp -d /new_data/hualin/db/uniprot_sprot_diamond -q $_ -e 1e-5 -f 6 -o $out -k 1 --sensitive -p 30 --query-cover 50");
}
