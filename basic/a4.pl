#!/usr/bin/perl

use strict;

my $output = `cat --help`;
my $lsOutput = `ls`;
my $lsUsingSystem = system('ls --help');
my $lsUsingExec = exec("ls -l");
# print $output;
# print $lsOutput;
# print $lsUsingSystem;
print $lsUsingExec;