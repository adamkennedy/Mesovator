#!/usr/bin/perl

# Trivial setup of a scenario to test for silly crashes

# Would love to do specific exception testing, but probably no time for that.

use 5.010;
use strict;
use warnings;
use Test::More;
use t::lib::Data;

my $pax = t::lib::Data->load_passengers("trivial.csv");
is( scalar(@$pax), 1, "Found 1 journey" );
isa_ok( $pax->[0], 'My::Passenger' );

ok(defined $pax->[0]->arrival_time, 'pax 0 arrival');
ok(defined $pax->[0]->entry_floor, 'pax 0 entry');
ok(defined $pax->[0]->exit_floor, 'pax 0 exit');
ok(not defined $pax->[0]->entry_time);
ok(not defined $pax->[0]->exit_time);

my $controller = My::Controller->new(
	floors => 10,
	elevators => 16,
);
isa_ok($controller, 'My::Controller');

my $simulator = My::Simulator->new(
	controller => $controller,
	passengers => $pax,
);
isa_ok($simulator, 'My::Simulator');

done_testing();
