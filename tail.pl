#!/usr/bin/perl -w

#Program that emulates the linux tail function

@files = ();
$n = 10;

foreach $arg (@ARGV){
    if(substr($arg,0,1) eq "-"){
	    $arg =~ s/^.//;
	    $n = $arg
    } else {
	    push @files, $arg;
    }
}

if ($#files + 1 == 0) {
    @output = ();
    while (<>){
	    push @output, $_;
    }
    if ($#output+1 > $n){
	    @output = @output[$#output+1-$n..$#output];
    }
    print @output;
}

foreach $f (@files){
    if(! -e $f){
	    print "tail.pl can't open $f\n";
	    next;
    }
    open(F, "<$f") or die "$0: Can't open $f $!\n";
    if($#files+1 > 1){
        print "==> $f <==\n";
    }
	@output = ();
	while($line = <F>){
	    push @output, $line;
	}
	if ($#output+1 > $n){
	    @output = @output[$#output+1-$n..$#output];
	}
	print @output;
    close(F);
}
