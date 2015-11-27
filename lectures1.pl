#!/usr/bin/perl -w

#Usage: perl lectures1.pl [-t|-d] [courseCode]
#Eg: perl lectures1.pl -t COMP3421 MATH1131
#Flags: t - returns lecture times in a table format
#       d - returns the hourly details

#Program that returns lecture times for given courses at UNSW

$dFlag = 0;
$tFlag = 0;
if ($ARGV[0] eq "-d"){
    $dFlag = 1;
    shift @ARGV;
} elsif ($ARGV[0] eq "-t"){
    $tFlag = 1;
    shift @ARGV;
}
foreach $course(@ARGV){
    open F, "wget -q -O - http://timetable.unsw.edu.au/current/$course.html|" or die;
    $session = 0;
    $times = "";
    while ($line = <F>){
	if(index($line, "Lecture<") != -1){
	    for (1..1){
		$line = <F>;
	    }
	    $line =~ s/\s*//g;
	    $line =~ s/\<.*?\>//g;
	    $line =~ s/t/S/i;
	    $line =~ s/u/X/i;
	    $session = $line;
	    for (1..5){
		$line = <F>;
	    }
	    $line =~ s/^\s*//g;
	    $line =~ s/\s*$//g;
	    $line =~ s/\<.*?\>//g;
	    if($line eq ""){
		last;
	    }
	    $times = $line;
	    if ($dFlag || $tFlag) {
		$times =~ s/,//g;
		@days = ($times =~ /([a-z]{3}) /gi);
		@startTimes = ($times =~ /[a-z]{3} ([0-9]{2})\:/gi);
		@endTimes = ($times =~ /\- ([0-9]{2})\:/g);
		@endMinutes = ($times =~ /\- [0-9]{2}\:([0-9]{2})/g);
		for $n (0..scalar @endTimes -1){
		    if ($endMinutes[$n] eq "30"){
			$endTimes[$n]++;
			if($endTimes[$n] == 13){ $endTimes[$n] = 1;}
		    }
		}
		if(scalar @startTimes < scalar @days){
		    push(@startTimes, (@startTimes) x (scalar @days - scalar @startTimes));
		    push(@endTimes, (@endTimes) x (scalar @days - scalar @endTimes));
		}
		$currDay = 0;
		%tableTimes = ();
		for $n (9..20){
		    $tableTimes{"Mon"}{$n} = 0;
		    $tableTimes{"Tue"}{$n} = 0;
		    $tableTimes{"Wed"}{$n} = 0;
		    $tableTimes{"Thu"}{$n} = 0;
		    $tableTimes{"Fri"}{$n} = 0;
		}
		for $n (0..scalar @startTimes - 1){
		    $hours = $endTimes[$n] - $startTimes[$n];
		    if ($hours == 1){
			if($tFlag){
			    $tableTimes{$days[$currDay]}{$startTimes[$n]} = 1;
			} else {
			    print "$session $course $days[$currDay] $startTimes[$n]\n";
			}
			$currDay++;
		    } else {
			for $i (0..$hours-1){
			    if ($tFlag){
				$tableTimes{$days[$currDay]}{$startTimes[$n]+$i} = 1;
			    } else {
				print "$session $course $days[$currDay] " . ($startTimes[$n]+$i) . "\n";
			    }
			}
			$currDay++;
		    }
		}
		if($tFlag){
		    print "$session\tMon\tTue\tWed\tThu\tFri\n";
		    for $n (9..20){
			printf "%.2d:00\t", $n;
			if($tableTimes{Mon}{$n}){
			    print "$tableTimes{Mon}{$n}" . "\t";
			} else {
			    print "\t";
			}
			if($tableTimes{"Tue"}{$n}){
			    print "$tableTimes{\"Tue\"}{$n}" . "\t";
			} else {
			    print "\t";
			}
			if($tableTimes{"Wed"}{$n}){
			    print "$tableTimes{\"Wed\"}{$n}" . "\t";
			} else {
			    print "\t";
			}
			if($tableTimes{"Thu"}{$n}){
			    print "$tableTimes{\"Thu\"}{$n}" . "\t";
			} else {
			    print "\t";
			}
			if($tableTimes{"Fri"}{$n}){
			    print "$tableTimes{\"Fri\"}{$n}" . "\t";
			} else {
			    print "\t";
			}
			print "\n";
		    }
		}
	    } else {
		print "$course: $session $times\n";
	    }
	}
    }
    close F;
}
