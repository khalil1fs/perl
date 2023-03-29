#!/usr/bin/perl
#==============================================================
# Auteur : khalil1fs
# But    : Plugin Nagios CPU Usage
# Date   : 28/03/2023
#==============================================================
 
use warnings;
use strict;

# define a string to search for matches
my $string = "The quick brown fox jumps over the lazy dog.";

# check if the string starts with "The"
if ($string =~ /^The/) {
    print "The string starts with 'The'.\n";
} else {
    print "The string does not start with 'The'.\n";
}

# check if the string ends with "dog."
if ($string =~ /dog\.$/) {
    print "The string ends with 'dog.'. \n";
} else {
    print "The string does not end with 'dog.'.\n";
}

# match and extract the word between "fox" and "over"
if ($string =~ /fox\s+(.*?)\s+over/) {
    my $match = $1;
    print "The word between 'fox' and 'over' is: $match.\n";
} else {
    print "No match found.\n";
}

# split the string into words and print them out
my @words = split(/\s+/, $string);
print "Words in the string: @words\n";



__END__