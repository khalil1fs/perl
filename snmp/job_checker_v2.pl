#!/usr/bin/perl -w
#=============================================================#
# Auteur : khalil1fs                                          #
# But    : Job checker Plugin                                 #  
# Date   : 28/03/2023                                         #  
#=============================================================#
 
use warnings;
use strict;
use JSON;
# https://perldoc.perl.org/Getopt::Long :Docs
use Getopt::Long;
use LWP::Simple;

# winrm / pywinrm
# https://stackoverflow.com/questions/73667/how-can-i-start-an-interactive-console-for-perl
# https://stackoverflow.com/questions/4284313/how-can-i-check-the-syntax-of-python-script-without-executing-it
# perl job_checker_v2.pl -w 20 -c 50 -u   https://webhook.site/8ad01e63-34b3-4450-b165-ff6c6e225d95
# perl job_checker_v2.pl -w 200 -c 500 -u https://webhook.site/8ad01e63-34b3-4450-b165-ff6c6e225d95
# perl job_checker_v2.pl -w 200 -c 500 -u https://webhook.site/8ad01e63-34b3-4450-b165-ff6c6e225d95 -p 0d20h30m -n '.*'

my $Name = "Data Checker";
my $Version = "1.0.0";
my $copyright = "Copyright © Khalil1fs 2023 - tous droits réservés.";
my $o_help = undef; 		    # wan't some help ?
my $o_regex = undef; 		    # Filter jobs names by regex
my $o_datetime_filter = undef; 		    # Filter jobs names by regex
my $time_delay = undef;
my $o_url = undef; 		    # Request Url for jobs
my $o_crit = undef; 		    # critical for critical status 
my $o_warn = undef; 		    # critical for warnning status 
my $exit_code = 0;

check_options();


my $response = get($o_url) or die 'Unable to load data';
my $data = decode_json($response);
my $result_array = $data->{'result'};

# get the length of the whole array
my $total_jobs_length = scalar(@{$result_array});
my %jobs_by_status;

# Prepare and filter the list of jobs
prepare();

# print the jobs grouped by status
print_result('Fail', 'Critical', @{$jobs_by_status{'Fail'}});
print_result('Pending', 'Warnning', @{$jobs_by_status{'Pending'}});
print_result('Ok', 'Ok', @{$jobs_by_status{'Ok'}});


exit($exit_code);

sub filter_by_name {
   my ($job) = @_;
   if (defined ($o_regex)) {
       if ($job->{'name'} =~ /$o_regex/) {
         return 1;
      }else {
       return -1;
      }
  } else {
     return 1;
  }
}

sub filter_by_datetime {
   my ($job) = @_;
   if (defined ($o_datetime_filter)) {
       if ($job->{'timestamp'} >= $time_delay) {
         return 1;
      }else {
         return -1;
      }
  } else {
     return 1;
  }
}

sub get_time_in_sec {
    if ($o_datetime_filter =~ /(\d+)d(\d+)h(\d+)m/) {
       return $1 * 86400 + $2 * 3600 + $3 * 60;
     } else {
       die "Invalid time format\n";
       exit(3);
    }
}

# print the final result
sub print_result {
    my ($status, $reference, @jobs) = @_;
      print "Status: $reference \n";
         foreach my $job (@jobs) {
         print "\tName: $job->{'name'}, Timing: $job->{'time'}, state: $job->{'status'}\n";
       }
}

sub check_ok_status {
   my ($job) = @_;
   my $status_by_timing = get_status_by_timing($job->{'time'});

   if ($status_by_timing == 0) {
      push @{$jobs_by_status{'Ok'}}, $job;
   } elsif ($status_by_timing == 1) {
      push @{$jobs_by_status{'Pending'}}, $job; 
      if ($exit_code == 0) {     
         $exit_code = 1;}
   } else {
      push @{$jobs_by_status{'Fail'}}, $job;
      $exit_code = 2;
   }
}

sub check_pending_status {
   my ($job) = @_;
   
   if (get_status_by_timing($job->{'time'}) <= 1) {
      push @{$jobs_by_status{'Pending'}}, $job;    
      if ($exit_code == 0){      
         $exit_code = 1;}
   } else {
      push @{$jobs_by_status{'Fail'}}, $job;
      $exit_code = 2;
   }
}

# prepare the list of jobs and group by ('Ok', 'Pending', 'Fail') status 
sub prepare {
     foreach my $job (@{$result_array}) {
      if (filter_by_datetime($job) == 1 && filter_by_name($job) == 1){
      if ($job->{'status'} eq 'Ok') {
           check_ok_status($job);    
      } elsif ($job->{'status'} eq 'Pending') {
           check_pending_status($job);
      } elsif ($job->{'status'} eq 'Fail') {
           push @{$jobs_by_status{'Fail'}}, $job;
           $exit_code = 2;
      } 
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
        'h'     => \$o_help,    	   'help'        	=> \$o_help,
        'n:s'   => \$o_regex,   		'regex:s'	    => \$o_regex,
        'p:s'   => \$o_datetime_filter,
        'u:s'   => \$o_url,   		'url:s'	    => \$o_url,
        'c:i'   => \$o_crit,        'critical:i'    => \$o_crit,
        'w:i'   => \$o_warn,        'warn:i'        => \$o_warn,
	) or die("Error in command line arguments\n");
	
    if (defined ($o_help)) { 
       help();
       exit(0);
      }

    if (!defined($o_url) || !defined($o_warn) || !defined($o_crit)) {
       print "Put all required params!\n"; 
       print_usage();
       exit(3)
     }
     
    if ($o_crit < $o_warn) {
       print "ATTENTION : critique < warning";
       exit(3);
     }

     if (defined ($o_datetime_filter)) { 
        my $elapsed_time = get_time_in_sec();
        $time_delay = time() - $elapsed_time;
     }
}

sub print_usage {
    print "Usage: $Name -u <request url for jobs> -w <warn level> -c <crit level> -p <filter by date '1d2h3m'> -n <filter by regex path>\n";
}

sub help {
   print "\n$Name";
   print "MIT licence, (c)2023 Khalil1fs\n\n";
   print_usage();
   print <<EOT;
-h, --help
   print this help message 
-w, --warn=INTEGER | INT,INT,INT
-p
-n
   warning level for job timing
-c, --crit=INTEGER | INT,INT,INT
   critical level for job timing 
-u, --url=STRING
   request url for jobs
-V, --Version
	Print release version
EOT
}


sub printVersion {
   print "$Name v$Version\n";
   print "$copyright\n";
}


__END__