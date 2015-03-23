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

	unless (_POSINT($self->floors)) {
		die "Missing or invalid floors";
	}
	unless (_POSINT($self->elevators)) {
		die "Missing or invalid elevators";
	}

	return $self;
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

sub floor_up_button_pressed {
	my $self = shift;
	my $floor = shift;

	# Null implementation
}

sub floor_down_button_pressed {
	my $self = shift;
	my $floor = shift;

	# Null implementation
}

1;
