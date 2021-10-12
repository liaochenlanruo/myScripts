#!/usr/bin/perl
use strict;
use warnings;
# Author: Liu hualin
# Date: Sep 30, 2021

my @faa = glob("*.faa");# ��ȡ���к�׺Ϊ��.faa�����ļ��������Լ�����
foreach  (@faa) {
	$_=~/(.+).faa/;
	my $out = $1 . ".CAZy.diamond";
	# -p��ʾ�߳������ڱʼǱ�����6������
	system("diamond blastp -d CAZy -q $_ -e 1e-5 -f 6 -o $out -k 1 --sensitive -p 30 --query-cover 50");
}
