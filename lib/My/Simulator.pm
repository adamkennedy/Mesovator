package My::Simulator;

use 5.010;
use strict;
use warnings;
use Params::Util ':ALL';
use List::Util 'first';
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

	# Build a mutatable queue for the passenger list so we don't mutate
	# the original passenger list.
	$self->{queue} = [ @{$self->passengers} ];

	# Set up simulation state
	$self->{tick} = 0;
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

sub lobby {
	$_[0]->{lobbies}->[$_[1]] or die "Missing or invalid floor";
}

sub elevator {
	$_[0]->{elevators}->[$_[1]] or die "Missing or invalid elevator";
}





######################################################################
# Simulator
# Provides the run-loop and basic state manipulation. In any situation
# where I had more time I'd split this out.

sub run {
	my $self = shift;

	# Track the simulation halting
	my $halting = 0;

	while ( not $halting ) {
		$self->{tick}++;
		$halting = 1;

		# Handle the accidental infinite loop
		if ($self->{tick} > 1_000_000_000) {
			die "Aborting simulation, ran too long";
		}

		# New passengers arrive
		while ( $self->{queue}->[0] and $self->{queue}->[0]->arrival_time == $self->{tick} ) {
			$self->passenger_arrival(shift @{$self->{queue}});
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

sub passenger_arrival {
	my $self      = shift;
	my $passenger = shift;
	my $floor     = $passenger->entry_floor;

	# We naively get into any elevator stopped here
	my $elevator = first { $_->is_stopped_at($floor) } @{$self->elevators};
	if ($elevator) {
		# The passenger boards and presses the floor button
		$elevator->add_passenger($passenger);
		$self->controller->elevator_floor_button_pressed($elevator, $passenger->exit_floor);
		$passenger->{entry_time} = $self->{tick};
	} else {
		my $lobby = $self->lobby($floor);
		if ($passenger->exit_floor > $floor) {
			$self->controller->floor_up_button_pressed($floor);
		} else {
			$self->controller->floor_down_button_pressed($floor);
		}
	}
}

1;
