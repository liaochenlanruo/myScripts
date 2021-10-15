#!/usr/bin/perl
use strict;
use warnings;
# Author: Liu Hualin
# Date: Oct 15, 2021

open OUT, ">Statistics.txt" || die;
print OUT "Strain name\tSignal peptide numbers\tSecretory protein numbers\tMembrane protein numbers\n";
my @sig = glob("*_signalp");
foreach my $sig (@sig) {
	$sig=~/(.+)_signalp/;
	my $str = $1;
	my $tmhmm = $sig . "/$str" . "_TMHMM_SHORT.txt";
	my $fasta = $sig . "/$str" . ".sigseq";
	my $secretory = $str . ".secretory.faa";
	my $membrane = $str . ".membrane.faa";
	open SEC, ">$secretory" || die;
	open MEM, ">$membrane" || die;
	my $out = 0;
	my $on = 0;
	my %hash = idseq($fasta);
	open IN, $tmhmm || die;
	while (<IN>) {
		chomp;
		$_=~s/[\r\n]+//g;
#		print $_ . "\n";
		my @lines = split /\t/;
		if ($lines[5] eq "Topology=o") {
			$out++;
			print SEC ">$lines[0]\n$hash{$lines[0]}\n";
		}else {
			$on++;
			print MEM ">$lines[0]\n$hash{$lines[0]}\n";
		}
	}
	close IN;
	close SEC;
	close MEM;
	system("mv $secretory $membrane $sig");
	my $total = $out + $on;
	print OUT "$str\t$total\t$out\t$on\n";
}

close OUT;

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
