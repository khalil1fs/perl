#!/usr/bin/perl
#===============================================================================
# Auteur : khalil1fs                                                           #
# Date   : 27/03/2023
# But    : Example of function in Perl
#===============================================================================
use strict;
use warnings;
use Scalar::Util qw(looks_like_number);

sub add {
    my ($num1, $num2) = @_;
    if(!looks_like_number($num1) || !looks_like_number($num2)) {
        die "Error: add() function requires numeric arguments\n";
    }
    return $num1 + $num2; 
}

print "sum: ".add(23, 21);

