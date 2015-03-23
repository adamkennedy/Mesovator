package My::Simulator;

use 5.010;
use strict;
use warnings;
use Params::Util ':ALL';
use My::Controller;
use My::Passenger;
use My::Elevator;
use My::Lobby;

use Object::Tiny qw{
	controller
	passengers
	lobbies
	elevators
};

our $VERSION = '0.01';

sub new {
	my $self = shift->SUPER::new(@_);

	# Check params
	unless (_INSTANCE($self->controller, "My::Controller")) {
		die "Missing or invalid controller";
	}
	unless (_SET($self->passengers, "My::Passenger")) {
		die "Missing or invalid passengers";
	}

	# Set up simulation state
	$self->{lobbies} = [
		map {
			My::Lobby->new(floor => $_)
		} 
		(0 .. $self->controller->floors - 1)
	];
	$self->{elevators} = [
		map {
			My::Elevator->new(id => $_)
		}
		(0 .. $self->controller->elevators - 1)
	];

	return $self;
}





######################################################################
# Simulator
# Provides the run-loop and basic state manipulation. In any situation
# where I had more time I'd split this out.

sub run {
	my $self = shift;

	# Might as well be private until the controller needs to be time aware
	my $tick = 0;

	# Track the simulation halting
	my $halting = 0;

	while ( not $halting ) {
		$tick++;
		$halting = 1;

		# Handle the accidental infinite loop
		if ($tick > 1_000_000_000) {
			die "Aborting simulation, ran too long";
		}

		# New passengers arrive
		my $pax = $self->passengers;
		while ( $pax->[0] and $pax->[0]->arrival_time == $tick ) {
			$self->passenger_arrives(shift @$pax);
			$halting = 0;
		}

		# Handle elevator mechanics
		foreach my $elevator (@{$self->elevators}) {
			# Start the elevator toward the first destination if they
			# are stopped and have a destination in queue.
			if ($elevator->is_stopped and $elevator->has_destination) {
				$elevator->start($elevator->current_destination);
			}

			if (not $elevator->is_stopped) {
				# Apply current velocity
				$elevator->_move;

				# Stop the elevator when we reach our destination
				if ($elevator->_floor == $elevator->current_destination) {
					$elevator->stop;
				}
			}

		}
	}

	return 1;
}

sub passenger_arrives {
	my $self = shift;
	my $passenger = shift;
}

1;
