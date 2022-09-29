# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Derml.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => last_test_to_print;
use Test::Exception;
BEGIN { use_ok('Derml') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

dies_ok { Derml::derml() }   'Derml requires one parameter';
dies_ok { Derml::derml('alkdfhwaodfna', 'adlfhaowwhn', 'gfajogpwifna') }	'Passing in too many parameters';