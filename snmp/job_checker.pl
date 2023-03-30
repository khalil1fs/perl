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

# perl job_checker.pl -w 20 -c 50 -u https://webhook.site/fef8ca9d-a0f7-46b4-b489-59efed2caea7
# perl job_checker.pl -w 200 -c 500 -u https://webhook.site/8ad01e63-34b3-4450-b165-ff6c6e225d95

my $Name = "Data Checker";
my $Version = "1.0.0";
my $copyright = "Copyright © Khalil1fs 2023 - tous droits réservés.";
my $o_help = undef; 		    # wan't some help ?
my $o_regex = undef; 		    # Filter jobs names by regex
my $o_datetime_filter = undef; 		    # Filter jobs names by regex
my $o_url = undef; 		    # Request Url for jobs
my $o_crit = undef; 		    # critical for critical status 
my $o_warn = undef; 		    # critical for warnning status 
my $exit_code = 0;

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
foreach my $s ('Fail', 'Pending', 'Ok') { # Critiqual, Warnning
   print_result($s, @{$jobs_by_status{$s}});
}

filter_by_name();
filter_by_datetime();

# print "$exit_code";
exit($exit_code);

sub filter_by_name {
   if (defined ($o_regex)) {
      print "\nList of Job's filtered By Name:\n\n"; 
        foreach my $job (@$result_array) {
         if ($job->{'name'} =~ /$o_regex/) {
         print "name: $job->{'name'}, timing: $job->{'time'}, state: $job->{'status'}\n";
      }
   }
  }
}


sub filter_by_datetime {
   if (defined ($o_datetime_filter)) {
         my $elapsed_time = get_time_in_milli();
         print "\nList of Job's filtered By elapsed Time:\n\n"; 
         my $time_delay = time() - $elapsed_time;
        foreach my $job (@$result_array) {
         if ($job->{'timestamp'} >= $time_delay) {
         print "name: $job->{'name'}, timing: $job->{'time'}, state: $job->{'status'}, jot_timeStamp: $job->{'timestamp'} -- $time_delay\n";
      }
    }      
  }
}

sub get_time_in_milli {
    if ($o_datetime_filter =~ /(\d+)d(\d+)h(\d+)m/) {
      return $1 * 86400 + $2 * 3600 + $3 * 60;
   } else {
     die "Invalid time format\n";
     exit(3);
    }
}

# print the final result
sub print_result {
    my ($status, @jobs) = @_;
    my $jobs_length = scalar(@jobs);
    if ($jobs_length > 0) {
      print "Status: " .get_status($status). "\n";
         foreach my $job (@jobs) {
         print "\tName: $job->{'name'}, Timing: $job->{'time'}, state: $job->{'status'}\n";
       }
    }
}

sub check_ok_status {
   my ($job) = @_;
   my $status_by_timing = get_status_by_timing($job->{'time'});

   if ($status_by_timing == 0) {
      push @{$jobs_by_status{'Ok'}}, $job;
   } elsif ($status_by_timing == 1) {
      push @{$jobs_by_status{'Pending'}}, $job;    
      $exit_code = 1;
   } else {
      push @{$jobs_by_status{'Fail'}}, $job;
      $exit_code = 2;
   }
}

sub check_pending_status {
   my ($job) = @_;
   
   if (get_status_by_timing($job->{'time'}) <= 1) {
      push @{$jobs_by_status{'Pending'}}, $job;    
      $exit_code = 1;
   } else {
      push @{$jobs_by_status{'Fail'}}, $job;
      $exit_code = 2;
   }
}

# prepare the list of jobs and group by ('Ok', 'Pending', 'Fail') status 
sub prepare {
     foreach my $job (@{$result_array}) {
      if ($job->{'status'} eq 'Ok') {
           check_ok_status($job);    
      }
      elsif ($job->{'status'} eq 'Pending') {
           check_pending_status($job);
      }
      elsif ($job->{'status'} eq 'Fail') {
           push @{$jobs_by_status{'Fail'}}, $job;
           $exit_code = 2;
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
      };

    if (!defined($o_url) || !defined($o_warn) || !defined($o_crit)) {
       print "Put all required params!\n"; 
       print_usage();
       exit(3)
     }
    if ($o_crit < $o_warn) {
       print "ATTENTION : critique < warning";
       exit(3);
     }
}


sub get_status {
   my ($status) = @_;
   if ($status eq "Fail"){
      return "Critiqual";
   }elsif ($status eq "Pending") {
      return "Warnning";
   }else {
      return "Ok";
   }
}

sub print_usage {
    print "Usage: $Name -u <request url for jobs> -w <warn level> -c <crit level>\n";
}

sub help {
   print "\n$Name";
   print "MIT licence, (c)2023 Khalil1fs\n\n";
   print_usage();
   print <<EOT;
-h, --help
   print this help message 
-w, --warn=INTEGER | INT,INT,INT
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