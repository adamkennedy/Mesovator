package My::Simulator;

use 5.010;
use strict;
use warnings;
use Params::Util ':ALL';
use My::Controller;
use My::Passenger;
use My::Elevator;

use Object::Tiny qw{
	controller
	passengers

	floors
	lobby
	call_up
	call_down
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
	$self->{floors}    = $self->controller->floors;
	$self->{lobby}     = [ [] x $self->floors ];
	$self->{call_up}   = [ 0 x $self->floors  ];
	$self->{call_down} = [ 0 x $self->floors  ];

	return $self;
}





######################################################################
# Simulator
# Provides the run-loop and basic state manipulation. In any situation
# where I had more time I'd split this out.

sub run {
	return 1;
}

1;
