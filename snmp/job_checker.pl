#!/usr/bin/perl -w
#=============================================================#
# Auteur : khalil1fs                                          #
# But    : Plugin Nagios CPU Usage                            #  
# Date   : 28/03/2023                                         #  
#=============================================================#
 
use warnings;
use strict;
use JSON;
use Getopt::Long;
use LWP::Simple;


my $Name = "Data Checker";
my $Version = "1.0.0";
my $copyright = "Copyright © Khalil1fs 2023 - tous droits réservés.";
my $request_url = "https://webhook.site/fef8ca9d-a0f7-46b4-b489-59efed2caea7";
my $o_help=	undef; 		    # wan't some help ?
my $o_url = undef; 		    # Request Url
my $o_crit = undef; 		# la valeur critique
my $o_warn = undef; 		# la valeur warnning

my $content = get($request_url) or die 'Unable to get page';
# my %data = @{$content{"result"}};
# my @data = $cont->{"result"};
# print %{$cont{"result"}};
# print %data;
# my $data = $cont->{"result"};
# my @data = $decoded_data->{'result'};
# foreach my $item (@$data) {
#     print "$item ";
# }
# print "@decoded_data";


sub print_usage {
    print "Usage: $Name -u <request url> -w <warn level> -c <crit level>\n";
}

sub help {
   print "\n$Name";
   print "\nData Checker\n";
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
        'u:s'   => \$o_url,   		'url:s'	    => \$o_url,
        'c:s'   => \$o_crit,        'critical:s'    => \$o_crit,
        'w:s'   => \$o_warn,        'warn:s'        => \$o_warn,
	);
	
    if (defined ($o_help)) { help(); exit(0)};
    # check snmp information
    if (!defined($o_url) || !defined($o_warn) || !defined($o_crit))
        { print "Put snmp login info!\n"; print_usage(); exit(3)}
	if ($o_crit < $o_warn){
		print "ATTENTION : critique < warning";
		exit(3);
	}
}


__END__