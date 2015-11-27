#!/usr/bin/perl -w

#Program that emulates the paste -s unix command

foreach $f (@ARGV){
    open(F, "<$f") or die "$0: Can't open $f $!\n";
    $output = "";
    while($line = <F>){
        $line =~ s/\n/\t/g;
	$output = $output . $line;
    }
    $output =~ s/\s+$//;
    print "$output\n";
    close(F);
}
