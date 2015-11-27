#!/usr/bin/perl -w

#Usage: perl id.pl poem?.txt
#Program goes through a list of poets and their texts, recording their word usage
#This data is then matched against the word usage in the given poem.txt
#Implements a Naive Bayes Classifier

foreach $poem (@ARGV){
    #hash for words in poem
    %words = ();
    #hash for each poets total log 
    %wordFreq = ();
 
    open F, "<$poem" or die;
    #count the words in the poem
    while ($line = <F>){
	foreach $word(split /[^a-zA-Z]/, $line){
	    if ($word ne ""){
		$words{$word}++;
	    }
	}
    }
    close F;
    #loop though each poet
    foreach $poetFile (glob "poets/*.txt"){
	$poetFile =~ /([a-z_]+)\./gi;
	$poet = $1;
	$poet =~ s/[\._]/ /gi;

	open F, "<$poetFile" or die;
	$numWords = 0;
	while($line = <F>){
	    $numWords += () = $line =~ /[a-z]+/gi;
	}
	seek F, 0, 0;
	foreach $word(keys %words){
	    while($line = <F>){
		$wordFreq{$poet}{$word} += () = $line =~ /\b($word)\b/gi;
	    }
	    $wordFreq{$poet}{$word} = log(($wordFreq{$poet}{$word} + 1)/$numWords);
	    seek F, 0, 0;
	}
	close F;
    }
    %totalFreq = ();
    foreach $poet (keys %wordFreq){
	foreach $word (keys %{$wordFreq{$poet}}){
	    $totalFreq{$poet} += $wordFreq{$poet}{$word}*$words{$word};
	}
    }
    $max = (reverse sort {$totalFreq{$a} <=> $totalFreq{$b}} keys %totalFreq)[0];
    printf "%s most resembles the work of %s (log-probability=%.1f)\n", $poem, $max, $totalFreq{$max};
}
