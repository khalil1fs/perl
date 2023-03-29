#!/usr/bin/perl
#===============================================================================
# Auteur : djibril
# Date   : 28/03/2023
# But    : Plugin verifiant l'existance d'un fichier 
#===============================================================================
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

my ( $fichier_a_verifier ) = ();
GetOptions( 'file|f=s' => \$fichier_a_verifier );

if (not defined $fichier_a_verifier ) {
    print "Il manque l'argument --file ou -f\n";
    exit 0;
}

my $NOM_PROCESS = 'CheckFileExiste';
my $nom_fichier = basename $fichier_a_verifier;

#  Check if the file exist
if ( -e $fichier_a_verifier ) {
    print "$NOM_PROCESS OK - $nom_fichier exists\n";
    exit 0;
} else {
    print "$NOM_PROCESS Critical - $nom_fichier not exists\n";
    exit 2;
}
# run: 
#        perl check_file_exist.pl -f /home/khalil/Schreibtisch/data7.yml
#        ./check_file_exist.pl -f /home/khalil/Schreibtisch/data7.yml

__END__