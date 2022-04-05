# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Parser-Derml.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More;
use Test::Exception;
BEGIN { use_ok('Parser::Derml'); };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $filename = random_string();

dies_ok { Parser::Derml::parse } 'filename parameter absent, should die';        # Croak at filename parameter is absent
dies_ok { Parser::Derml::parse filename => $filename } 'non existent file, should die';   # Croak at non-existent file

setup();


done_testing();

# Subroutine to create a random file

sub setup {
    open(my $file, '>', $filename);
    say $file "# A derml file";
    close $file;
}


# Subroutine for creating a random string. Pass in the length of the string
# as parameter.
sub random_string {
    my $length = shift;
    $length ||= 8;
    my $temp = '';
    my @chars = ('a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '-');
    $temp .= $chars[ int(rand(@chars)) ] for(1 .. $length);
}