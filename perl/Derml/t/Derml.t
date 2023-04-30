# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Derml.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

#use Test::More tests => last_test_to_print;
use Test::More;
# use Test::Exception;
BEGIN { use_ok('Derml') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $param_1 = generate_random_string();
my $param_2 = generate_random_string();
my $param_3 = generate_random_string();

my $filename = generate_random_string();

dies_ok { Derml::derml() }   'Derml requires one parameter';
dies_ok { Derml::derml($param_1, $param_2, $param_3) }	'Passing in too many parameters';
dies_ok { Derml::derml($filename) }	'Non-existent file';

done_testing;

# Returns a random string
sub generate_random_string {
	my $result = '';
	my @chars = ('A' .. 'Z', 'a' .. 'z', '0' .. '9', '-', '_');
	$result .= $chars[ int(rand(@chars))] for(1..16);
	return $result;
}

# Creates a file
sub create_file {
	my $fname = generate_random_string();
	open(my $f, '>', $fname);
	say $f "Test File";
}
