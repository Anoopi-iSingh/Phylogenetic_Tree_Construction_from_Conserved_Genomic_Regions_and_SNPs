#!/usr/bin/perl -w

#command  : perl snp_extract.pl <list.txt> <Seq.tab>
$list = $ARGV[0] or die "can not open file $!";

unless (open(LIST, $list)){
	print "can not open file $!";


};

$seq = $ARGV[1] or die "can not open file $!";

unless (open(SEQ, $seq)){
	print "can not open file $!";


};

@l=<LIST>;


for($i=0;$i<=9;$i++)

{
	chomp ($a=$l[$i]);
	$n= $i+1;
	$cut=`cut -f $n $seq  > $a`;
	$n_rm=`sed -i ':a;N;\$\!ba;s/\\n//g' $a`;
	$header1 = `sed -i 's/\^/\>\\n/g' $a`;
	$a =~ /^(.+?)\.fasta$/i;
	$a1 = $1;

	$header2= `awk '/\^\>/{print ">""$a1"; next}{print}' $a > $a1.fna`;
	$rm = `rm $a`;

};
