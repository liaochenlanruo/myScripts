#!/usr/bin/perl
use strict;
use warnings;

my %maps;
my @diaout = glob("*.diamond");# 读取所有的diamond比对后的输出文件
foreach  (@diaout) {
	$_=~/(\S+).diamond/;
	my %hash;
	open IN, "$_" || die;
	while (<IN>) {
		chomp;
		$_=~s/[\r\n]+//g;
		my @lines = split;
		$lines[1]=~/.+\|(.+)\|.+/;
		$hash{$1}++;
	}
	close IN;

	open IN, "idmapping_selected.tab" || die;
	while (<IN>) {
		chomp;
		$_=~s/[\r\n]+//g;
		my @lines = split;
		if (exists $hash{$lines[0]}) {
			$maps{$lines[0]} = $_;
		}
	}
	close IN;
}

my @diaout2 = glob("*.diamond");# 读取所有的diamond比对后的输出文件
foreach  (@diaout2) {
	$_=~/(\S+).diamond/;
	my $out = $1 . ".mapped";
	open IN, "$_" || die;
	open OUT, ">$out" || die;
	print OUT "qseqid\tsseqid\tpident\tlength\tmismatch\tgapopen\tqstart\tqend\tsstart\tsend\tevalue\tbitscore\tUniProtKB-AC	UniProtKB-ID	GeneID (EntrezGene)	RefSeq	GI	PDB	GO	UniRef100	UniRef90	UniRef50	UniParc	PIR	NCBI-taxon	MIM	UniGene	PubMed	EMBL	EMBL-CDS	Ensembl	Ensembl_TRS	Ensembl_PRO	Additional PubMed\n";
	while (<IN>) {
		chomp;
		$_=~s/[\r\n]+//g;
		my @lines = split;
		$lines[1]=~/.+\|(.+)\|.+/;
		if (exists $maps{$1}) {
			print OUT $_ . "\t" . $maps{$1} . "\n";
		}else {
			print OUT $_ . "\n";
		}
	}
	close IN;
	close OUT;
}