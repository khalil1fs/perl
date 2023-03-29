#!/usr/bin/perl
#==============================================================
# Auteur : khalil1fs
# But    : Plugin Nagios permettant de vérifier l'existence d'un
#          processus via le nom
# Date   : 05/03/2011 12:38:44
#==============================================================
 
use warnings;
use strict;
use Monitoring::Plugin;
use Proc::ProcessTable;
 
use vars qw/ $VERSION /;
 
# Version du plugin
$VERSION = '1.0';
 
my $LICENCE
  = "Ce plugin Nagios est gratuit et libre de droits, et vous pouvez l'utiliser à votre convenance."
  . ' Il est livré avec ABSOLUMENT AUCUNE GARANTIE.';
 
my $plugin_nagios = Monitoring::Plugin->new(
  shortname => 'Check Process plugin',
  usage     => 'Usage: %s [ -proc_name|-n=<Process name> ]',
  version   => $VERSION,
  license   => $LICENCE,
);
 
# Définition des options de ligne de commande
# 1- Récupération du nom du processus
$plugin_nagios->add_arg(
  spec     => 'critical_value|n=s',
  help     => 'Process name to find',
  required => 1,
);



# Parser les options
$plugin_nagios->getopts;
my $critical_value = $plugin_nagios->opts->critical_value;
# my $proc_ext = $plugin_nagios->opts->proc_extension;

# if ($proc_ext -eq 'vide') {
#     print "yes";
# } 

print "$proc_name";
# print "$proc_ext";
 
# Recherche du processus
# if ()
my $process_table = new Proc::ProcessTable;
my $FORMAT        = "%-6s %-10s %-8s %-24s %s\n";
foreach my $proc ( @{ $process_table->table } ) {
  if ( $proc->fname eq $proc_name ) {
    my $message_OK = "Process $proc_name (" . $proc->pid . ') state (' . $proc->state . ')';
 
    # Option verbose
    if ( $plugin_nagios->opts->verbose ) {
      printf( $FORMAT, 'PID', 'TTY', 'STAT', 'START', 'COMMAND' );
      printf( $FORMAT, $proc->pid, $proc->ttydev, $proc->state, scalar(localtime($proc->start)), $proc->cmndline);
    }
    $plugin_nagios->plugin_exit( OK, $message_OK );
  }
}
$plugin_nagios->plugin_exit(CRITICAL, "$proc_name not found\n");
 
__END__