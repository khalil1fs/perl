#===============================================================================
# Auteur : khalil1fs
# Date   : 28/03/2023
# But    : Plugin vérifiant l'existence d'un fichier
#===============================================================================
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

# run test 
# perl check_file_exist.pl -f /home/khalil/Desktop/test
 
my ( $fichier_a_verifier ) = ();
GetOptions( 'file|f=s' => \$fichier_a_verifier );
if ( not defined $fichier_a_verifier ) {
  print "Il manque l'argument --file ou -f\n";
  exit 0;
}
 
my $NOM_PROCESS = 'CheckFileExiste';
my $nom_fichier = basename  $fichier_a_verifier;
# Vérification de l'existence du fichier
if ( -e $fichier_a_verifier ) {
  print "$NOM_PROCESS OK - $nom_fichier exists\n";
  exit 0;
}
else {
  print "$NOM_PROCESS CRITICAL - $nom_fichier not exists\n";
  exit 2;
}
 
__END__