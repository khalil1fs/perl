#!/usr/bin/perl
use strict;
use warnings;


# Hash: when you see the => operator, you now that you are dealing with a hash
# key => value
my %langs = ( England => 'English',
	              France => 'French', 
    	          Spain => 'Spanish', 
    	          China => 'Chinese', 
	              Germany => 'German');

my $lang = $langs{'England'};
print($lang, "\n");

# Add new Element to the hash
$langs{'Italy'} = 'Italien';
print($langs{'Italy'}, "\n");

# Update Element
$langs{'India'} = 'A lot';

# Remove element
delete $langs{'China'};

print($langs{'India'}, "\n");

#  Loop throught element in Hash
for(keys %langs) {
    # $_ : is a special variable
    print("Official language of $_ is $langs{$_}\n");
}

if (1==1){
    print "1";
}elsif(1==2) {
    print "2";
}else {
    print "3";
}


my %rates = (
     USD => 1,
     YPY => 82.25,
     EUR => 0.78,
     GBP => 0.62,
     CNY => 6.23
);

print("Supported currency: \n");
for(keys %rates){
    print(uc($_),":  $rates{$_}", "\n");
}
