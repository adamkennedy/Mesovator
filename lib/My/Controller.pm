package My::Controller;

use 5.010;
use strict;
use warnings;
use Params::Util ':ALL';
use Object::Tiny qw{
	floors
	elevators
};

our $VERSION = '0.01';

sub new {
	my $self = shift->SUPER::new(@_);

	unless (_POSINT($self->floors) and $self->floors > 1) {
		die "Missing or invalid floors";
	}
	unless (_POSINT($self->elevators)) {
		die "Missing or invalid elevators";
	}

	return $self;
}

sub top_floor {
	$_[0]->floors - 1;
}

# HACK - Should refactor where things live, but no time.
# HACK - Give the controller access to the simulator so it can get to the
# HACK - lobby and elevator collections. This fuck composability and creates
# HACK - entanglements hard to unwind in testing. Blerk.
sub simulator {
	$_[0]->{simulator} or die "Simulation is not currently running";
}





######################################################################
# Event Handlers

sub elevator_floor_button_pressed {
	my $self     = shift;
	my $elevator = shift;
	my $floor    = shift;

	# Null implementation
}

sub elevator_stopped_at_floor {
	my $self = shift;
	my $elevator = shift;
	my $floor = shift;

	# Null implementation
}

sub elevator_idle {
	my $self = shift;
	my $elevator = shift;

	# Null implementation
}

sub lobby_up_button_pressed {
	my $self = shift;
	my $floor = shift;

	# Null implementation
}

sub lobby_down_button_pressed {
	my $self = shift;
	my $floor = shift;

	# Null implementation
}

1;
