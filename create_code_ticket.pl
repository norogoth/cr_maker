use strict;
use warnings;

=head1
This will take a file named, by default in the code, "default_cr.txt" and it will format what you write to create a new code review. For example:
# INPUT
/home/diogenes/ops/confex/create_code_ticket.pl
sub example
changed one thing
changed another thing
/home/diogenes/abstract/confex/other file.pl
sub asdf
changed everything

will get you
#OUTPUT
/home/diogenes/ops/confex/create_code_ticket.pl
*::sub example
*:::changed one thing
*:::changed another thing
*: {d:abstract/confex/other file.pl}
*::sub asdf
*:::changed everything

You can also pass a RM number on the command line in order to take a file named 12345_cr.txt and to output to a file called 12345_cr_output.txt.

For more details, you can ping Landon or observe the code below.
=cut

my $ticketNumber = $ARGV[0];
my $basepath = '/home/diogenes/confex/code_review/';
my $default = 'default_code_review';
my $fileInput = $ticketNumber ?  $basepath . $ticketNumber . "_cr.txt" : $basepath . $default."_input.txt";
my $fileOutput = $ticketNumber ?  $basepath . $ticketNumber . "_cr_output.txt" : $basepath . $default."_output.txt";

open my $i, '<',$fileInput or die "Whoops: cannot open input file: " . $fileInput . ".";
open my $o, '>',$fileOutput or die "Whoops: cannot open output file: " . $fileOutput . ".";
my $lineCounter = 1;
my $title = "untitled";
my $submode = 0;
while (defined(my $line = <$i>)){
	my $lineToWrite = "";
	next if length($line) < 2;
	if ($lineCounter == 1 && $line){
		$lineToWrite = $line;
	} 
	elsif (substr($line,0,1) eq "/"){
		my ($shortenedpath) = $line =~ /^.*?((ops|abstract|grant).*)/;
		$lineToWrite = "*: {d:".$shortenedpath."}\n" or die "regex failed: perhaps path did not have ops or abstract in it?";
	}
	elsif (substr($line,0,3) eq "sub"){
		$lineToWrite = "*::".$line;
	}
	else {
		$lineToWrite = "*:::".$line;
	}
	print $o $lineToWrite;
	$lineCounter++;
}
