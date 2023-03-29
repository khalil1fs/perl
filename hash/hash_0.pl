#!/usr/bin/perl
#==============================================================
# Auteur : khalil1fs
# But    : Plugin Nagios CPU Usage
# Date   : 28/03/2023
#==============================================================
 
use warnings;
use strict;


my %hash = (
    "apple" => 0.5,
    "banana" => 0.25,
    "orange" => 0.35
);


my @sorted_keys = sort { $hash{$a} <=> $hash{$b} } keys %hash;
foreach my $key (@sorted_keys) {
    my $value = $hash{$key};
    print "$key costs $value dollars.\n";
}


my $num_elements = scalar keys %hash;
print "The hash has $num_elements elements.\n";


if (exists $hash{"apple"}) {
    print "The hash contains an apple.\n";
} else {
    print "The hash does not contain an apple.\n";
}


delete $hash{"orange"};

$hash{"pear"} = 0.4;

while (my ($key, $value) = each %hash) {
    print "$key costs $value dollars.\n";
}

__END__
