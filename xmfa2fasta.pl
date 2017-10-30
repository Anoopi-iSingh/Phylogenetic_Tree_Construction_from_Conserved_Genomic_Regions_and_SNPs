#!/usr/bin/perl -w
# This script extracts core alignment in fasta format from xmaf file
# Lu Cheng
# 26.07.2013

# Input: .xmaf file, note that each block in the .xmaf file must contain the same number of sequences (see usage of stripSubsetLCBs)
#Output: .fasta file of the  core alignment

use strict;
use warnings;

my $inFile=$ARGV[0];

my $infh = ();
open($infh, $inFile) or die "Could not open file '$inFile' $!";
my $line = <$infh>;  # skip the first line
$line= <$infh>;
my $nSeq =0;
my @seqNames = ();
my $i = 0;
my @seqs = ();
my $tmp = ();

my $flag1=1;
while($line){
	if($line =~ /^#/){
		$nSeq=$nSeq+1;

		# handle the headers 
		$line =~ s/^#.*\t//;
		$line =~ s/^.*\///;
		$line =~ s/\..*$//;
		chomp($line);
		push(@seqNames,$line);
		
		$line=<$infh>; # skip the second line
		$line=<$infh>; # read the next line

	}elsif($line =~ /^>/){
	
		# read one sequence
		$tmp=();
		while(<$infh>){
			chomp($_);
			
			if(/^[=>]/){
				$line = $_;
				last;
			}else{
				chomp($_);
				$tmp = $tmp . $_;
			}
		}
		
		if(scalar(@seqs)<$nSeq){
			$seqs[$i] = $tmp;
		}else{
			$seqs[$i] = $seqs[$i] . $tmp;
		}
		
		$i = $i+1;
	}elsif($line =~ /^=/){
		$i=0;
		$line=<$infh>;
	}else{
		die "can not parse this file format!";
	}
}
close($infh);

my $outFile=$inFile;
$outFile=~s/\.xmfa//;
$outFile = $outFile . ".fasta";
my $outfh =();
open($outfh,">$outFile") or die "can not creat file $outFile $!";
for($i=0; $i<$nSeq;$i++){
	print $outfh ">$seqNames[$i]\n";
	while (my $chunk = substr($seqs[$i], 0,80, "")) {
               print $outfh "$chunk\n";
       }
       print $outfh "\n";
}
close($outfh);
