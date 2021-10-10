#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;

# Usage: perl download_NCBI.pl 列表文件 序列类型（参照https://www.ncbi.nlm.nih.gov/sites/batchentrez数据库填写，常用的包括nucleotide, protein）

my @ids;
my $dbtype = $ARGV[1];# nucleotide, protein

system("split -l 300 $ARGV[0] splited_");

my @splited = glob("splited_*");
foreach  (@splited) {
	$_=~/splited_(.+)/;
	my $out = "seqs.$1.fasta";
	open IN, $_ || die;
	while (<IN>) {
		chomp;
		$_=~s/[\r\n]+//g;
		push @ids, $_;
	}
	getstore("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=$dbtype&rettype=fasta&retmode=text&id=".join(",", @ids),"$out");
	@ids = ();
	close IN;
}

system("cat seqs.* > All.sequences.fas");
system("rm splited_* seqs.*");
