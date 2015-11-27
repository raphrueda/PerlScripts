#!/usr/bin/perl -w

#Usage: perl log_probability.pl [word] 
#Program calculates the probability that a poet would use the given word
#Calculated using text from a list of poets known works

$word = $ARGV[0];
foreach $file (glob "poets/*.txt"){
    $file =~ /([a-z_]+)\./gi;
    $poet = $1;
    $poet =~ s/[\._]/ /gi;

    open F, "<$file" or die;
    $numWords = 0;
    $occurrences = 0;
    while ($line = <F>){
        $numWords += () = $line =~ /[a-z]+/gi;
        $occurrences += () = $line =~ /\b($word)\b/gi;
    }
    close F;
    $frequency = ($occurrences+1) / $numWords;
    $log = log($frequency);

    printf "log((%d+1)/%6d) = %8.4f %s\n", $occurrences, $numWords, $log, $poet;
}

