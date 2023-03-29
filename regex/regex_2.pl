#!/usr/bin/perl
#==============================================================
# Auteur : khalil1fs                                                           #
# But    : Plugin Nagios CPU Usage
# Date   : 28/03/2023
#==============================================================
 
use warnings;
use strict;

# define a string to search for matches
my $string = "The quick brown fox jumps over the lazy dog.";

# check if the string contains the word "fox"
if ($string =~ /fox/) {
    print "The string contains the word 'fox'.\n";
} else {
    print "The string does not contain the word 'fox'.\n";
}

# replace the word "lazy" with "active"
$string =~ s/lazy/active/;
print "Modified string: $string\n";

# match and extract all the words starting with "q"
my @matches = $string =~ /\bq\w+\b/g;
print "Words starting with 'q': @matches\n";

# remove all punctuation from the string
$string =~ s/[[:punct:]]//g;
print "String with punctuation removed: $string\n";


__END__