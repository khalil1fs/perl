#!/usr/bin/perl
#==============================================================
# Auteur : khalil1fs
# But    : Plugin Nagios CPU Usage
# Date   : 28/03/2023 15:00:00
#==============================================================
 
use warnings;
use strict;
use JSON;
use Monitoring::Plugin;
 
use vars qw/ $VERSION /;
 
# Version du plugin
$VERSION = '1.0';
 
my $LICENCE
  = "Ce plugin Nagios est gratuit et libre de droits, et vous pouvez l'utiliser à votre convenance."
  . " Il est livré avec ABSOLUMENT AUCUNE GARANTIE.";
 
my $plugin_nagios = Monitoring::Plugin->new(
  shortname => 'Check Process plugin',
  usage     => 'Usage: %s [ -proc_name|-n=<Process name> ]',
  version   => $VERSION,
  license   => $LICENCE,
);

# getopts: https://alvinalexander.com/perl/perl-getopts-command-line-options-flags-in-perl/

$plugin_nagios->add_arg(
  spec     => 'critical_value|c=n',
  help     => 'critique value',
  required => 0,
);

$plugin_nagios->add_arg(
  spec     => 'warning_value|w=n',
  help     => 'warning value',
  required => 0,
);


$plugin_nagios->getopts;
my $critical_value = $plugin_nagios->opts->critical_value;
my $warning_value = $plugin_nagios->opts->warning_value;
if (!defined $critical_value) {
    $critical_value = 80;
}
if (!defined $warning_value) {
    $warning_value = 50;
}

if ($critical_value <= $warning_value) {
    $plugin_nagios->plugin_exit(1, "warning value cannot be greather than or equal to the critical value\n");
}

my $mpstat_output = `mpstat -o JSON`;
my $decoded_json = decode_json($mpstat_output);
my $cpu_value = $decoded_json->{'sysstat'}->{'hosts'}->[0]->{'statistics'}->[0]->{'cpu-load'}->[0]->{'usr'};
print "cpu: $cpu_value\n";
print "cpu: $cpu_value\n";

if ($cpu_value >= $critical_value) {
    $plugin_nagios->plugin_exit(2, "Critical\n");
} elsif($cpu_value >= $warning_value) {
    $plugin_nagios->plugin_exit(1, "Warning\n");
} else {
    $plugin_nagios->plugin_exit(0, "Ok\n");
}

 
__END__
