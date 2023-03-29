#!/usr/bin/perl
#==============================================================
# Auteur : khalil1fs
# But    : Plugin Nagios CPU Usage
# Date   : 28/03/2023 15:00:00
#==============================================================
 
use warnings;
use strict;


my %hash = (
    "apple" => {
        "color" => "red",
        "size" => "medium",
        "price" => 0.5
    },
    "banana" => {
        "color" => "yellow",
        "size" => "large",
        "price" => 0.25
    },
    "orange" => {
        "color" => "orange",
        "size" => "small",
        "price" => 0.35
    }
);


my $apple_color = $hash{"apple"}{"color"};
print "The color of an apple is $apple_color.\n";


while (my ($fruit, $attributes) = each %hash) {
    print "Fruit: $fruit\n";
    while (my ($attribute, $value) = each %$attributes) {
        print "\t$attribute: $value\n";
    }
}


$hash{"banana"}{"shape"} = "curved";

delete $hash{"orange"}{"size"};

if (exists $hash{"apple"}{"price"}) {
    print "The price of an apple is known.\n";
} else {
    print "The price of an apple is unknown.\n";
}

__END__
