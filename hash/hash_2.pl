#!/usr/bin/perl
#==============================================================
# Auteur : khalil1fs                                                           #
# But    : Plugin Nagios CPU Usage
# Date   : 28/03/2023
#==============================================================
 
use warnings;
use strict;

my %hash = (
    "fruits" => ["apple", "banna", "orange"],
    "vegetables" => ["carrot", "celery", "broccoli"],
    "meats" => ["chicken", "beef", "pork"]
);

push @{$hash{"fruits"}}, "pear";

while (my ($category, $items) = each %hash) {
    print "Category: $category\n";
    print "Items: ";
    foreach my $item (@$items) {
        print "$item ";
    }
    print "\n";
}

my $removed_item = splice @{$hash{"vegetables"}}, 1, 1;
print "Removed item: $removed_item\n";

if (grep {$_ eq "brocoli" } @{$hash{"vegetables"}}) {
    print "Brocoli is a vegetable.\n";
} else {
    print "Brocoli is not a vegetable.\n"
}

__END__
