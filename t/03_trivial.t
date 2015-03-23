#!/usr/bin/perl

# Set up a trivial passenger scenario for testing and debugging the basic
# execution flow.

# 3 floors (0,1,2)
# 1 passenger movement (0 -> 2)

use 5.010;
use strict;
use warnings;
use Test::More;
use t::lib::Data;





# Set up the simulation

my $pax = t::lib::Data->load_passengers("passengers.csv");

my $controller = My::Controller->new(
	floors => 3,
	elevators => 1,
);
isa_ok($controller, 'My::Controller');

my $simulator = My::Simulator->new(
	controller => $controller,
	passengers => $pax,
);
isa_ok($simulator, 'My::Simulator');




# Run the simulation

ok($simulator->run, '->run ok');




# Check the results

ok(defined $pax->[0]->arrival_time);
ok(defined $pax->[0]->entry_floor);
ok(defined $pax->[0]->exit_floor);
ok(defined $pax->[0]->entry_time, '->entry_time set');
ok(defined $pax->[0]->exit_time, '->exit_time set');

done_testing();
