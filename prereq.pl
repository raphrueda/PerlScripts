#!/usr/bin/perl -w

#Program that finds the prerequistes to courses offered at UNSW

@urls = ("http://www.handbook.unsw.edu.au/undergraduate/courses/2014/". $ARGV[0] .".html", 
	 "http://www.handbook.unsw.edu.au/postgraduate/courses/2014/". $ARGV[0] .".html"); 
foreach(@urls){
    open F, "wget -q -O - $_|" or die;
    while ($line = <F>){
	    if(index($line, "Prereq") != -1){
	        $line =~ /(Prereq.*?\<\/p>)/;
	        $courseCodes = "[A-Z]{4}[0-9]{4}";
	        @prereq = $1 =~ /($courseCodes)/g;
	        foreach(@prereq){
		    print "$_\n";
	        }
	    }
    }
    close F;
}
