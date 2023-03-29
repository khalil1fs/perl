#!/usr/bin/perl
#==============================================================
# Auteur : khalil1fs
# But    : Plugin Nagios CPU Usage
# Date   : 28/03/2023 15:00:00
#==============================================================
 
use warnings;
use strict;

my $string = "The quick brown fox jumps over the lazy dog.";

if ($string =~ /fox/) {
    print "The string contains the word 'fox'.\n";
} else {
    print "The string does not contain the word 'fox'.\n";
}

if ($string =~ /\bq\w*/) {
    print "The string contains a word starting with 'q'.\n";
} else {
    print "The string does not contain a word starting with 'q'.\n";
}

$string =~ s/the/THE/g;
print "After replacing 'the' with 'THE': $string\n";

while ($string =~ /\bj\w*s\b/g) {
    my $match = $&;
    print "Match found: $match\n";
}


__END__