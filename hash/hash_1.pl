#!/usr/bin/perl
#==============================================================
# Auteur : khalil1fs                                                           #
# But    : Plugin Nagios CPU Usage
# Date   : 28/03/2023
#==============================================================
 
use warnings;
use strict;

my %hash = (
    "apple" => 3,
    "banana" => 4,
    "orange" => 5,
);

$hash{"pear"} = 1;

my $apple_count = $hash{"apple"};
print "There are $apple_count apples.\n"; 

while (my ($fruit, $count) = each %hash) {
    print "Thre are $count $fruit(s).\n";
}

delete $hash{"orange"};

if (exists $hash{"orange"}) {
    print "There are still oranges.\n";
} else {
    print "There are no more oranges.\n";
}

__END__
