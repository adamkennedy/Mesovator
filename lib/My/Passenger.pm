package My::Passenger;

use 5.010;
use strict;
use warnings;
use Params::Util ':ALL';
use Object::Tiny qw{
	arrival_time
	entry_floor
	entry_time
	exit_floor
	exit_time
};

our $VERSION = '0.01';

sub new {
	my $self = shift->SUPER::new(@_);

	# Basic validation
	unless (_POSINT($self->arrival_time)) {
		die "Missing or invalid arrival time";
	}
	unless (defined _NONNEGINT($self->entry_floor)) {
		die "Missing or invalid entry floor";
	}
	unless (defined _NONNEGINT($self->exit_floor)) {
		die "Missing or invalid exit floor";
	}
	if ($self->entry_floor == $self->exit_floor) {
		die "Exit floor is the same as entry floor";
	}

	return $self;
}

sub going_up {
	$_[0]->exit_floor > $_[0]->entry_floor;
}

sub going_down {
	$_[0]->exit_floor < $_[0]->entry_floor;
}

1;
