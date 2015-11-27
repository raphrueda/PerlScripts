#!/usr/bin/perl -w

#Usage: perl courses.pl [course prefix]
#Eg: COMP, VISN, MATH
#Program that returns all the courses with the given prefix offered at UNSW

$url = "http://www.timetable.unsw.edu.au/current/$ARGV[0]KENS.html";
open F, "wget -q -O - $url|" or die "$!";
    while ($line = <F>){
	    if(index($line, "\>$ARGV[0]") != -1){
	        $line =~ /([A-Z]{4}[0-9]{4})/g;
	        print "$1\n";
	    }
    }
close F;
