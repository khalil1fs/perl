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

# perl job_checker.pl -w 2000 -c 5000 -u https://webhook.site/fef8ca9d-a0f7-46b4-b489-59efed2caea7

my $Name = "Data Checker";
my $Version = "1.0.0";
my $copyright = "Copyright © Khalil1fs 2023 - tous droits réservés.";
my $request_url = "https://webhook.site/fef8ca9d-a0f7-46b4-b489-59efed2caea7";
my $o_help=	undef; 		    # wan't some help ?
my $o_url = undef; 		    # Request Url
my $o_crit = undef; 		# la valeur critique
my $o_warn = undef; 		# la valeur warnning


check_options();

my $response = get($o_url) or die 'Unable to get page';
my $data = decode_json($response);
my $result_array = $data->{'result'};

# get the length of the whole array
my $total_jobs_length = scalar(@{$result_array});
my %jobs_by_status;

# Prepare the list of jobs
prepare();

# print the jobs grouped by status
print_result('Ok', 0, @{$jobs_by_status{'Ok'}});
print_result('Pending', 1, @{$jobs_by_status{'Pending'}});
print_result('Fail', 2, @{$jobs_by_status{'Fail'}});


sub prepare {
     foreach my $job (@{$result_array}) {
         if ($job->{'status'} eq 'Ok') {
            my $status_by_timing = get_status_by_timing($job->{'time'});
         if ($status_by_timing == 0) {
           push @{$jobs_by_status{'Ok'}}, $job;
         } elsif ($status_by_timing == 1) {
           push @{$jobs_by_status{'Pending'}}, $job;    
         } else {
           push @{$jobs_by_status{'Fail'}}, $job;
         }
      }
      elsif ($job->{'status'} eq 'Pending') {
         if (get_status_by_timing($job->{'time'}) <= 1) {
           push @{$jobs_by_status{'Pending'}}, $job;    
         } else {
           push @{$jobs_by_status{'Fail'}}, $job;
         }
      }
      elsif ($job->{'status'} eq 'Fail') {
           push @{$jobs_by_status{'Fail'}}, $job;
      } 
    }
}

sub print_result {
    my ($status, $code, @jobs) = @_;
    my $jobs_length = scalar(@jobs);
      if ($jobs_length == $total_jobs_length) {
         print "All Jobs are $status, exit code $code\n";
         exit(0);
    } elsif ($jobs_length > 0) {
      print "Status: $status, code: $code\n";
         foreach my $job (@jobs) {
         print "\tName: $job->{'name'}, Timing: $job->{'time'}, state: $job->{'status'}\n";
       }
    }
}


sub get_status_by_timing {
    my ($timing) = @_;
   if ($timing >= $o_crit) {
      return 2;
   } elsif($timing >= $o_warn) {
      return 1;
   } else {
      return 0;
   }    
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
        { print "Put all required params!\n"; print_usage(); exit(3)}
	if ($o_crit < $o_warn){
		print "ATTENTION : critique < warning";
		exit(3);
	}
}


sub print_usage {
    print "Usage: $Name -u <request url> -w <warn level> -c <crit level>\n";
}

sub help {
   print "\n$Name";
   print "\nData Checker\n";
   print "MIT licence, (c)2023 Khalil1fs\n\n";
   print_usage();
   print <<EOT;
-h, --help
   print this help message 
-w, --warn=INTEGER | INT,INT,INT
   warning level for cpu in percent 
-c, --crit=INTEGER | INT,INT,INT
   critical level for cpu in percent 
-u, --url=STRING
   api url to get response
-V, --Version
	Print version
EOT
}


sub printVersion {
   print "$Name v$Version\n";
   print "$copyright\n";
}


__END__