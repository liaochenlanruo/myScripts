#!/usr/bin/perl
use strict;
use warnings;

my @faa = glob("*.faa");# ��ȡ���к�׺Ϊ��.faa�����ļ��������Լ�����
foreach  (@faa) {
	$_=~/(.+).faa/;
	my $out = $1 . ".diamond";
	# ��/new_data/hualin/db/uniprot_sprot_diamond�����Լ������ݿ�·��; -p��ʾ�߳������ڱʼǱ�����6������
	system("diamond blastp -d /new_data/hualin/db/uniprot_sprot_diamond -q $_ -e 1e-5 -f 6 -o $out -k 1 --sensitive -p 30 --query-cover 50");
}