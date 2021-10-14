#!/usr/bin/perl
use strict;
use warnings;
# Author: Liu Hualin
# Date: Oct 14, 2021


open IDNOSEQ, ">IDNOSEQ.txt" || die;
my @faa = glob("*.faa");
foreach  (@faa) {
	$_ =~ /(.+).faa/;
	my $str = $1;
	my $out = $1 . ".nodesc";
	my $sigseq = $1 . ".sigseq";
	my $outdir = $1 . "_signalp";
	open IN, $_ || die;
	open OUT, ">$out" || die;
	while (<IN>) {
		chomp;
		if (/^(>\S+)/) {
			print OUT $1 . "\n";
		}else {
			print OUT $_ . "\n";
		}
	}
	close IN;
	close OUT;
	my %hash = idseq($out);
	system("signalp6 --fastafile $out --organism other --output_dir $outdir --format txt --mode fast");
	my $gff = $outdir . "/output.gff3";
	if (! -z $gff) {
		open IN, "$gff" || die;
		<IN>;
		open OUT, ">$sigseq" || die;
		while (<IN>) {
			chomp;
			my @lines = split /\t/;
			if (exists $hash{$lines[0]}) {
				print OUT ">$lines[0]\n$hash{$lines[0]}\n";
			}else {
				print IDNOSEQ $str . "\t" . "$lines[0]\n";
			}
		}
		close IN;
		close OUT;
	}
	system("rm $out");
	system("mv $sigseq $outdir");
}
close IDNOSEQ;


sub idseq {
	my ($fasta) = @_;
	my %hash;
	local $/ = ">";
	open IN, $fasta || die;
	<IN>;
	while (<IN>) {
		chomp;
		my ($header, $seq) = split (/\n/, $_, 2);
		$header =~ /(\S+)/;
		my $id = $1;
		$hash{$id} = $seq;
	}
	close IN;
	return (%hash);
}
