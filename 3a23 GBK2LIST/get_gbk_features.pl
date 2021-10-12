#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;
# Author: Liu hualin
# Date: Oct 9, 2021
# Usage: perl get_gbk_features.pl <in> <out>

my $in = shift;
my $out = shift;
my $seqin = Bio::SeqIO->new( -format => 'genbank', -file => "$in");
open OUT, ">$out" || die;
while( (my $seq = $seqin->next_seq) ) {
	foreach my $sf ( $seq->get_SeqFeatures ) {
		if( $sf->primary_tag eq 'CDS' ) {
			my @tags = $sf ->get_all_tags();
			#print join("\t", @tags) . "\n";
			print OUT $sf->get_tag_values('locus_tag'), "\t", $sf->start, "\t", $sf->end, "\t", $sf->strand, "\t", $sf->get_tag_values('product'), "\t", $sf->get_tag_values('translation'),"\n";
		}
	}
}
