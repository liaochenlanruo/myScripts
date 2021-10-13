#!/usr/bin/perl
use strict;
use warnings;
# Author: Liu hualin
# Date: Oct 13, 2021

# Download modules
# 记录一个深坑，程序默认在module的路径前加了一个"./module"路径，因此，虽然程序安装的过程中自动下载了modules，然而我们并没有办法调用它们，只能重新下载。
# 以下代码在当前目录下创建了module目录，并下载modules，然后将其存到module目录中。
system("mkdir -p module");
system("curl -o TTSS_STD-2.0.2.jar https://depot.galaxyproject.org/software/TTSS_STD/TTSS_STD_2.0.2_src_all.jar");
system("curl -o TTSS_ANIMAL-1.0.1.jar https://depot.galaxyproject.org/software/TTSS_ANIMAL/TTSS_ANIMAL_1.0.1_src_all.jar");
system("curl -o TTSS_PLANT-1.0.1.jar https://depot.galaxyproject.org/software/TTSS_PLANT/TTSS_PLANT_1.0.1_src_all.jar");
system("curl -o TTSS_STD-1.0.1.jar https://depot.galaxyproject.org/software/TTSS_STD/TTSS_STD_1.0.1_src_all.jar");
system("mv -f TTSS_STD-2.0.2.jar TTSS_ANIMAL-1.0.1.jar TTSS_PLANT-1.0.1.jar TTSS_STD-1.0.1.jar module");

# Predict one by one
my @faa = glob("*.faa");
foreach  (@faa) {
	$_=~/(.+).faa/;
	my $out = $1 . ".T3";
	system("effectivet3 -f $_ -m TTSS_STD-2.0.2.jar -t selective -o $out -q");
}

# information aggregation
my (%hash, %strain);
my $line_num = 0;
open T3, ">T3SS.txt" || die;
print T3 "Strain\tId\tDescription\tScore\tis secreted\tProtein sequences\n";
my @t3 = glob("*.T3");
foreach my $t3 (@t3) {
	$t3=~/(.+).T3/;
	my $str = $1;
	my $faa = $1 . ".faa";
	$strain{$str}++;
	my %temp;
	# Save ID and Sequence to %temp
	open FAA, "$faa" || die;
	local $/ = ">";
	<FAA>;
	while (<FAA>) {
		chomp;
		my ($header, $seq) = split (/\n/, $_, 2);
		$header=~/(\S+)/;
		my $id = $1;
		$seq=~s/[\r\n]+//g;
		$temp{$id} = $seq;
	}
	close FAA;
	local $/ = "\n";
	open IN, "$t3" || die;
	<IN>;
	while (<IN>) {
		chomp;
		if (!/^#/) {
			my @lines = split /\;/;
			if ($lines[3] eq "true") {
				$line_num++;
				print T3 "$str\t" . join("\t", @lines) . "\t" . $temp{$lines[0]} . "\n";
				$hash{$str}{true}++;
			}else {
				$hash{$str}{false}++;
			}
		}
	}
	close IN;
}
close T3;

if ($line_num > 1) {
	open T3NUM, ">T3SS.num" || die;
	print T3NUM "Strain\tTotal sequences\tT3S effective true\tT3S effective false\n";
	foreach  (sort keys %strain) {
		if ($hash{$_}{true} && $hash{$_}{false}) {
			my $total = $hash{$_}{true} + $hash{$_}{false};
			print T3NUM $_ . "\t" . $total . "\t" . $hash{$_}{true} . "\t" . $hash{$_}{false} . "\n";
		}elsif ($hash{$_}{true}) {
			$hash{$_}{false} = 0;
			my $total = $hash{$_}{true} + $hash{$_}{false};
			print T3NUM $_ . "\t" . $total . "\t" . $hash{$_}{true} . "\t" . $hash{$_}{false} . "\n";
		}else {
			$hash{$_}{true} = 0;
			my $total = $hash{$_}{true} + $hash{$_}{false};
			print T3NUM $_ . "\t" . $total . "\t" . $hash{$_}{true} . "\t" . $hash{$_}{false} . "\n";
		}
	}
	close T3NUM;
}

system("mkdir -p T3SS_result");
system("mv *.T3 T3SS.num T3SS.txt T3SS_result");