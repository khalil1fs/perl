#!/usr/bin/perl
use strict;
use warnings;

# Global variables
our $color = 'red';
# install external packages with: cpan Monitoring::Plugin
{
    # Naming
    # $4whatever / $email-address : not valid

    # Declaration
    my $longNumber = 1_234_567_890;
    my $a = 10;
    my $b = 20;
    # Reasign
    $a = 50;
    # Concat
    my $c = $a + $b;
    # String
    my $s = "Hello world";
    
    # print($s, ', c: ', $c);
    # print "\nThe result is: " . $c ."\n"; 
    # print "Long number: " . $longNumber . "\n"
}

# print 10 + 20, "\n";
# print "color: " . $color

# ();
# (10,20,30);
# ("this", "is", "a","list");

print(10,20,30, "\n"); # display 102030
print("this", "is", "a","list", "\n"); # display: thisisalist

my $x1 = 10;
my $x2 = "a string";
# print("complex list", $x1 , $x2 ,"\n");
# print(qw(red green blue), "\n"); # redgreenblue , replace(' ', '')
# print(
#        (1,2,3)[0] # 1 first element
# );
# # my $listOfNumbers = (1,2,3,4,5);
# print((1..100))
my @days = qw(Mon Tue Wed Thu Fri Sat Sun);
# print("$days[-1]", "\n");
my @weekend = @days[-2..-1]; # SatSun
# print @weekend
my @stack = ();
push(@stack, 1);
push(@stack, 2);

print("@stack", "\n")
