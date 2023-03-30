#!/usr/bin/perl
use strict;
use warnings;
use DBI;

# snmp 
my $dbh = DBI->connect("DBI:mysql:test_perl",'admin','admin');

die "failed to connect to MySQL database:DBI->errstr()" unless($dbh);

my $sth = $dbh->prepare("SELECT id, age, reference FROM person")
                   or die "prepare statement failed: $dbh->errstr()";

$sth->execute() or die "execution failed: $dbh->errstr()"; 

my($id, $ref, $age);

# loop through each row of the result set, and print it
while(($id, $ref, $age) = $sth->fetchrow()){
   print("id=$id, reference=$ref, age=$age\n");                   
}

$sth->finish();

$dbh->disconnect();