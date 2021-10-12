#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;
# Author: Liu hualin
# Date: Oct 12, 2021

my @gbk = glob("*.gbk");
foreach  (@gbk) {
	$_=~/(.+).gbk/;
	my $out = $1 . "_prophage";
#	system("PhiSpy.py $_ -o $out --phage_genes 1 --min_contig_size 5000 --output_choice 1 --color --phmms pVOGs.hmm --threads 8");
}

open OUT, ">All.prophages.txt" || die;# print prophages informations
print OUT "Strain\tPhage ID\tContig ID\tStart location of the prophage\tStop location of the prophage\tStart of attL\tEnd of attL\tStart of attR\tEnd of attR\tsequence of attL\tSequence of attR\tWhy this att site was chosen for this prophage\n";
# attachment (att) sites
open SEQ, ">All.prophages.seq" || die;# print prophages sequences
print SEQ "Strain\tPhage ID\tContig ID\tGene Start\tGene End\tStrand\tAnnotation\tProtein sequences\n";
my @result = glob("*_prophage");
foreach  (@result) {
	$_=~/(.+)_prophage/;
	my $str = $1;
	my $prophage = $_ . "/prophage_coordinates.tsv";
	if (! -z $prophage) {
		open IN, "$prophage" || die;
		while (<IN>) {
			chomp;
			my @lines = split /\t/;
			my $contig = $lines[1];
			my $gbk = $str . ".gbk";
			my $seqin = Bio::SeqIO->new( -format => 'genbank', -file => "$gbk");#需要在gbk文件所在的目录中运行命令!
			while( (my $seq = $seqin->next_seq) ) {
				foreach my $sf ( $seq->get_SeqFeatures ) {
					if ($seq->display_name eq $contig) {
						if( $sf->primary_tag eq 'CDS' ) {
							#print SEQ $str, "\t", $lines[0], "\t", $seq->display_name, "\t", $sf->start, "\t", $sf->end, "\t", $sf->strand, "\t", $sf->get_tag_values('product'), "\t", $sf->get_tag_values('translation'), $seq->seq,"\n";# Also print contig sequences
							print SEQ $str, "\t", $lines[0], "\t", $seq->display_name, "\t", $sf->start, "\t", $sf->end, "\t", $sf->strand, "\t", $sf->get_tag_values('product'), "\t", $sf->get_tag_values('translation'),"\n";# Only print Protein sequences
						}
					}
				}
			}
			print OUT $str . "\t" . $_ . "\n";
		}
		close IN;
	}
}
close OUT;
close SEQ;
