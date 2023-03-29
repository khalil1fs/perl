#!/usr/bin/perl -w
#
# Copyright © CoServIT 2010 – tous droits réservés.
# Avertissement : ce logiciel est protégé par le code de la propriété intellectuelle et le droit d’auteur.
# Toute personne ne respectant pas ces dispositions se rendra coupable du délit de contrefaçon et 
# sera passible des sanctions pénales prévues par la loi. En particulier, aucune reproduction, même 
# partielle, autres que celles prévues à l'article L 122-5 du code de la propriété intellectuelle, ne peut
# être faite de ce logiciel sans l'autorisation expresse de l'auteur.
# Les droits d’utilisation du logiciel sont régis par la relation contractuelle établie entre l’auteur et 
# l’utilisateur du logiciel.
# Aucun droit d’utilisation n’est consenti par l’auteur en l’absence de relation contractuelle.


# ./check_snmp_cpu.pl -l admin -x admin123 -w 40 -c 80 -H 127.0.0.1

use strict;
use warnings;
use Net::SNMP;
use Getopt::Long;

my $oid_cpu_nt = ".1.3.6.1.4.1.2021.10.1.3.2";

my $Name=$0;
my @tabNameScript = split("\/",$Name);
$Name = $tabNameScript[scalar(@tabNameScript)-1]; # récupération du nom du script seulement, sans son chemin relatif.
	
my $Version = "1.0.0";
my $copyright = "Copyright © CoServIT 2010 – tous droits réservés.";
my $o_version = undef;

my $o_host = undef; 		# hostname
my $o_community = undef; 	# community
my $o_port = 161; 		# port
my $o_help=	undef; 		# wan't some help ?
my $o_warn=	undef;		# warning level
my $o_crit=	undef;		# critical level
my $o_version2= undef;          # use snmp v2c
# SNMPv3 specific
my $o_login=	undef;		# Login for snmpv3
my $o_passwd=	undef;		# Pass for snmpv3
my $v3protocols=undef;	# V3 protocol list.
my $o_authproto='md5';		# Auth protocol
my $o_privproto='DES';		# Priv protocol
my $o_privpass= undef;		# priv password
my $o_timeout = undef;
my $o_perf = undef;

sub print_usage {
    print "Usage: $Name [-v] -H <host> -C <snmp_community> [-2] [-f] | (-l login -x passwd )  [-p <port>] -w <warn level> -c <crit level>\n";
}

sub help {
   print "\n$Name";
   print "\nSNMP Load & CPU Monitor for Nagios\n";
   print "GPL licence, (c)2004-2006 Patrick Proy\n\n";
   print_usage();
   print <<EOT;
-v, --verbose
   print extra debugging information 
-h, --help
   print this help message
-H, --hostname=HOST
   name or IP address of host to check
-C, --community=COMMUNITY NAME
   community name for the host's SNMP agent (implies v1 protocol)
-2, --v2c
   Use snmp v2c
-f, --perfparse
   Perfparse compatible output
-l, --login=LOGIN ; -x, --passwd=PASSWD
   Login and auth password for snmpv3 authentication 
   If no priv password exists, implies AuthNoPriv 
-X, --privpass=PASSWD
   Priv password for snmpv3 (AuthPriv protocol)
-p, --port=PORT
   SNMP port (Default 161)
-w, --warn=INTEGER | INT,INT,INT
   warning level for cpu in percent 
-c, --crit=INTEGER | INT,INT,INT
   critical level for cpu in percent 
-V, --Version
	Print version
EOT
}

sub printVersion {
   print "$Name v$Version\n";
   print "$copyright\n";
}


sub check_options {
    Getopt::Long::Configure ("bundling");
    GetOptions(
        'h'     => \$o_help,    	'help'        	=> \$o_help,
        'H:s'   => \$o_host,		'hostname:s'	=> \$o_host,
        'p:i'   => \$o_port,   		'port:i'	    => \$o_port,
        'C:s'   => \$o_community,	'community:s'	=> \$o_community,
	    'l:s'	=> \$o_login,		'login:s'	    => \$o_login,
	    'x:s'	=> \$o_passwd,		'passwd:s'	    => \$o_passwd,
	    '2'     => \$o_version2,    'v2c'           => \$o_version2,
        't:i'   => \$o_timeout,     'timeout:i'     => \$o_timeout,
        'c:s'   => \$o_crit,        'critical:s'    => \$o_crit,
        'w:s'   => \$o_warn,        'warn:s'        => \$o_warn,
        'f'     => \$o_perf,        'perfparse'     => \$o_perf,
		'V'   => \$o_version,       'Version'       => \$o_version	
	);
	
    if (defined ($o_help)) { help(); exit(3)};
	if (defined ($o_version)) { printVersion(); exit 3};
	if (!defined($o_timeout)) {$o_timeout=10;}
    # check snmp information
    if ( !defined($o_community) && (!defined($o_login) || !defined($o_passwd)) || !defined($o_warn) || !defined($o_crit) )
        { print "Put snmp login info!\n"; print_usage(); exit(3)}
    if ( ! defined($o_host) ) { print_usage(); exit(3)};
	if ($o_crit < $o_warn){
		print "ATTENTION : critique < warning";
		exit(3);
	}
}


########## MAIN #######

check_options();

# Connect to host
my ($session,$error);
if ( defined($o_login) && defined($o_passwd)) {
  # SNMPv3 login
  #verb("SNMPv3 login");
  ($session, $error) = Net::SNMP->session(
      -hostname         => $o_host,
      -version          => '3',
      -username         => $o_login,
      -authpassword     => $o_passwd,
      -authprotocol     => 'md5',
      -privpassword     => $o_passwd,
      -timeout          => $o_timeout
   );
} else {
  if (defined ($o_version2)) {
    # SNMPv2 Login
	($session, $error) = Net::SNMP->session(
       -hostname  => $o_host,
	   -version   => 2,
       -community => $o_community,
       -port      => $o_port,
       -timeout   => $o_timeout
    );
  } else {
  # SNMPV1 login
    ($session, $error) = Net::SNMP->session(
       -hostname  => $o_host,
       -community => $o_community,
       -port      => $o_port,
       -timeout   => $o_timeout
    );
  }
}


if (!defined($session)) {
   printf("ERROR: %s.\n", $error);
   exit(3);
}

my $resultat=undef;

 
 $resultat = $session->get_request(-varbindlist => [$oid_cpu_nt]);
 if (!defined($resultat)) {
    printf("ERROR: Description table : %s.\n", $session->error);
    $session->close;
    exit(3);
  }
  my $cpu_load = $resultat->{$oid_cpu_nt};
  #printf("cpu load : $cpu_load");
$session->close;
 
 if ($cpu_load > $o_crit){
	if (defined($o_perf)){
		printf("Processeur CRITICAL - utilisation : $cpu_load| cpu=$cpu_load\%\n");
	}else{
		printf("Processeur CRITICAL - utilisation : $cpu_load\n");
	}
	exit(2);
}elsif ($cpu_load > $o_warn){
	if (defined($o_perf)){
		printf("Processeur WARNING - utilisation : $cpu_load| cpu=$cpu_load\%\n");
	}else{
		printf("Processeur WARNING - utilisation : $cpu_load\n");
	}
	exit(1);
}else{
	if (defined($o_perf)){
		printf("Processeur OK - utilisation : $cpu_load| cpu=$cpu_load\%\n");
	}else{
		printf("Processeur OK - utilisation : $cpu_load\n");
	}
	exit(0);
}