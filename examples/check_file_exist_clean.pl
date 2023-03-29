#!/usr/bin/perl
#===============================================================================
# Auteur : khalil1fs
# Date   : 04/03/2011
# But    : Plugin vérifiant l'existence d'un fichier
#===============================================================================
use strict;
use warnings;
 
# Chargement du module
use Monitoring::Plugin;
use File::Basename;
 
use vars qw/ $VERSION /;
 
# Version du plugin
$VERSION = '1.0';
 
my $LICENCE
  = "Ce plugin Nagios est gratuit et libre de droits, et vous pouvez l'utiliser à votre convenance."
  . ' Il est livré avec ABSOLUMENT AUCUNE GARANTIE.';
 
my $plugin_nagios = Monitoring::Plugin->new(
  shortname => 'Verification fichier',
  usage     => 'Usage : %s [-f <file> ou --file <file> Or ]',
  version   => $VERSION,
  license   => $LICENCE,
);
 
# Définition de l'argument --file ou -f pour récupérer le fichier
$plugin_nagios->add_arg(
  spec     => 'file|f=s',
  help     => 'file to check',    # Aide au sujet de cette option
  required => 1,                  # Argument obligatoire
);
 
# $plugin_nagios->add_arg(
#   spec     => 'type=s',
#   help     => 'check the type of file',    # Aide au sujet de cette option
#   required => 1,                  # Argument obligatoire
# );
 
# Activer le parsing des options de ligne de commande
$plugin_nagios->getopts;
 
my $fichier_a_verifier = $plugin_nagios->opts->file;
my $nom_fichier        = basename $fichier_a_verifier;
 
# Vérification de l'existence du fichier
if ( $plugin_nagios->opts->verbose ) { print "Test du fichier $nom_fichier\n"; }
if ( -e $fichier_a_verifier ) {
  if ( $plugin_nagios->opts->verbose ) { 
    print "Fichier existant\n";
     }
  $plugin_nagios->plugin_exit( OK, "$nom_fichier exists" );
}
else {
  if ( $plugin_nagios->opts->verbose ) { print "Fichier inexistant\n"; }
  $plugin_nagios->plugin_exit( CRITICAL, "$nom_fichier not exists" );
}

__END__