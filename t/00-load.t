#!perl -T

use strict;
use warnings;

use Test::More tests => 24;

BEGIN {
	use lib qw{lib};
	use_ok( 'IPC::RunExternal' ) || print "Bail out!\n";
}

diag( "Testing IPC::RunExternal $IPC::RunExternal::VERSION, Perl $], $^X" );

use lib qw{lib};
use IPC::RunExternal;

my $EXIT_STATUS_OK = 1;
my $EXIT_STATUS_TIMEOUT = 0;
my $EXIT_STATUS_FAILED = -1;

my $TRUE = 1;
my $FALSE = 0;
my $EMPTY_STR = '';



my $command = $EMPTY_STR;
my $input = $EMPTY_STR;
my $timeout = 3;
my $exit_code = 0;
my $stdout = $EMPTY_STR;
my $stderr = $EMPTY_STR;
my $allout = $EMPTY_STR;

#goto last_test;
	can_ok('IPC::RunExternal', 'runexternal');

	$ENV{"PATH"} = ""; # Testing in tainted mode (-T)
	$ENV{"ENV"} = ""; # Testing in tainted mode (-T)
	# Running these tests requires Test::Exception, not supported!
	#isnt(runexternal(undef, $EMPTY_STR, 3), -1, "Invalid parameter causes failure (command)");
	#isnt(runexternal('date', 1, 3), -1, "Invalid parameter causes failure (input 1)");
	#isnt(runexternal('date', 1, -1), -1, "Invalid parameter causes failure (timeout)");
	# 3

	$ENV{"PATH"} = ""; # Testing in tainted mode (-T)
	$ENV{"ENV"} = ""; # Testing in tainted mode (-T)
	($exit_code, $stdout, $stderr, $allout) = runexternal('./qwert', $EMPTY_STR, 2);
	is($exit_code, $EXIT_STATUS_OK,                   "qwert Test result failure (1)");
	is($stdout, '',                                   "qwert Test result failure (2)");
	like($stderr, '/No such file or directory/',      "qwert Test result failure (3)");
	#like($stderr, '/No such file or directory/xmsg', "qwert Test result failure (4)");
	# 5

	$ENV{"PATH"} = ""; # Testing in tainted mode (-T)
	$ENV{"ENV"} = ""; # Testing in tainted mode (-T)
	($exit_code, $stdout, $stderr, $allout) = runexternal('echo "Test"', $EMPTY_STR, 2);
	is($exit_code, $EXIT_STATUS_OK,                   "Echo Test result (1)");
	is($stdout, "Test\n",                             "Echo Test result (2)");
	is($stderr, '',                                   "Echo Test result (3)");
	# 8

	$ENV{"PATH"} = ""; # Testing in tainted mode (-T)
	$ENV{"ENV"} = ""; # Testing in tainted mode (-T)
	($exit_code, $stdout, $stderr, $allout) = runexternal('/usr/bin/wc', 'QWERT', 2);
	is($exit_code, $EXIT_STATUS_OK,                   "Wc Test result (1)");
	#like($stdout, '/.*0.*1.*5.*/',          "Wc Test result (2)");
	is($stdout, "      0       1       5\n",          "Wc Test result (2)");
	is($stderr, '',                                   "Wc Test result (3)");
	# 11

	$ENV{"PATH"} = ""; # Testing in tainted mode (-T)
	$ENV{"ENV"} = ""; # Testing in tainted mode (-T)
	($exit_code, $stdout, $stderr, $allout) = runexternal('t/TestRunExternal_01.pl loop 2 simple', $EMPTY_STR, 3);
	is($exit_code, $EXIT_STATUS_OK,                                 "TestRunExternal_01.pl 2 simple result (1)");
	like($stdout, '/STDOUT:2/',          "TestRunExternal_01.pl 2 simple result (2)");
	#like($stdout, '/Going to run for 5 secs. Printing to STDOUT and STDERR./',          "TestRunExternal_01.pl 2 simple result (2)");
	like($stderr, '/STDERR:1/',          "TestRunExternal_01.pl 2 simple result (3)");
	#like($allout, '/STDOUT:2\$STDERR:1/',          "TestRunExternal_01.pl 2 simple result (4)");
	# 14

	$ENV{"PATH"} = ""; # Testing in tainted mode (-T)
	$ENV{"ENV"} = ""; # Testing in tainted mode (-T)
	($exit_code, $stdout, $stderr, $allout) = runexternal('t/TestRunExternal_01.pl loop 10', $EMPTY_STR, 3);
	is($exit_code, $EXIT_STATUS_TIMEOUT,                                 "TestRunExternal_01.pl Timeout result (1)");
	#like($stdout, '/.*This program is part of IPC::RunExternal package test suite.*/',          "TestRunExternal_01.pl Timeout result (2)");
	#like($stdout, '/Going to run for 5 secs. Printing to STDOUT and STDERR./',          "TestRunExternal_01.pl Timeout result (2)");
	like($stderr, '/Timeout/',          "TestRunExternal_01.pl Timeout result (3)");
	like($stderr, '/to STDERR/',          "TestRunExternal_01.pl Timeout result (3)");
	like($allout, '/.*Timeout*/',          "TestRunExternal_01.pl Timeout result (4)");
	# 18

	$ENV{"PATH"} = ""; # Testing in tainted mode (-T)
	$ENV{"ENV"} = ""; # Testing in tainted mode (-T)
	($exit_code, $stdout, $stderr, $allout) = runexternal('t/TestRunExternal_01.pl loop 4 simple', $EMPTY_STR, 0, 
			{ #print_progress_indicator => $TRUE
			});
	#print " END PROGRESS...\n";
	is($exit_code, $EXIT_STATUS_OK,      "TestRunExternal_01.pl loop 4 + print_prog_ind No timeout result (1)");
	like($stdout, '/STDOUT:4/',          "TestRunExternal_01.pl loop 4 + print_prog_ind  No timeout result (2)");
	like($stderr, '/STDERR:3/',          "TestRunExternal_01.pl loop 4 + print_prog_ind  No timeout result (3)");
	# 21

	$ENV{"PATH"} = ""; # Testing in tainted mode (-T)
	$ENV{"ENV"} = ""; # Testing in tainted mode (-T)
	($exit_code, $stdout, $stderr, $allout) = runexternal('t/TestRunExternal_01.pl loop 6', $EMPTY_STR, 3, 
			{ #print_progress_indicator => $TRUE,
				progress_indicator_char => '#'
			});
	#print " END PROGRESS...\n";
	is($exit_code, $EXIT_STATUS_TIMEOUT,                                 "TestRunExternal_01.pl loop 6 Timeout + progress_ind # result (1)");
	#like($stdout, '/STDOUT:6/',          "TestRunExternal_01.pl loop 6 Timeout + progress_ind # result (2)");
	like($stderr, '/.*Timeout*/',          "TestRunExternal_01.pl loop 6 Timeout + progress_ind # result (3)");
	# 23

	is(length($stdout) + length($stderr), length($allout), "TestRunExternal_01.pl output OK Timeout result (4)");
	# 24

