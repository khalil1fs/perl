#!/usr/bin/perl
#===============================================================================
# Auteur : khalil1fs
# Date   : 27/03/2023
# But    : Example of function in Perl
#===============================================================================
use strict;
use warnings;
 
sub add {
    my ($num1, $num2) = @_;
    return $num1 + $num2;
}

my $result = add(2, 3);
print "result: " . $result;

sub array_sum {
    my @arr = @_;
    my $sum = 0;
    foreach my $num (@arr) {
        $sum += $num;
    }
    return $sum;
}

my @my_array = (1, 2, 3, 4, 5);
my $result = array_sum(@my_array);
print "\nsum od array: " . $result;

sub printLine {
    my $message = shift;
    print "\n" . $message ."\n";
}

printLine("Hallo");