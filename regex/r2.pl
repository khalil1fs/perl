#!/usr/bin/perl
#===============================================================================
# Auteur : khalil1fs
# Date   : 28/03/2023
# But    : Exemple de plugin Nagios
#===============================================================================
use strict;
use warnings;

my $bar = "This is foo and again foo";
if ($bar =~ m[foo]) {
    print "0 ";
}else {
    print "1 ";
}

$bar = "foo";
if ($bar =~ /foo/) {
    print "1";
}else {
    print "0";
}

my $string = 'The cat sat on the mat';
$string =~ tr/a/o/;
# print "\n$string \n";


$string = "Cats go Catatonic\nWhen given Catnip";
my ($start) = ($string =~ /\A(.*?) /);
my @lines = $string =~ /^(.*?) /gm;
print "First word: $start\n","Line starts: @lines\n";

__END__
