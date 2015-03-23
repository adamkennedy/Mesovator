package My::Elevator;

# Implements a single elevator.
#
# Height is measured in hypothetical units, with floors occuring every 5 units.
#
# We don't implement any acceleration physics, because evelator physics is
# highly non-trivial due to human psychology and "jerk" factor.

use 5.010;
use strict;
use warnings;
use Params::Util ':ALL';
use Object::Tiny qw{
	id
	passengers
	destinations
};

our $VERSION = '0.01';

sub new {
	my $self = shift->SUPER::new(@_);

	# Debugging id
	unless (defined _NONNEGINT($self->id)) {
		die "Missing or invalid elevator id";
	}

	# Defaults
	$self->{passengers}   = [];
	$self->{destinations} = [];

	# Current vertical location of the elevator in hypothetical units.
	# Floors occur every 5 units.
	$self->{position} = 0;

	# The velocity we are travelling in hypothetical units.
	$self->{velocity} = 0;

	return $self;
}





######################################################################
# Actions

# Start an elevator moving towards a floor.
# Trying to start a moving elevator is a bad smell so lets be strict here
# despite time concerns.
sub start {
	my $self     = shift;
	my $position = shift;
	unless (defined _NONNEGINT($position)) {
		die "Missing or invalid position";
	}
	if ($self->{velocity}) {
		die "Attempted to start a moving elevator";
	}

	if ($position > $self->{position}) {
		$self->{velocity} = 1;
	} elsif ($position < $self->{position}) {
		$self->{velocity} = -1;
	} else {
		die "Elevator already at the destination";
	}
}

# Stop an elevator wherever it is.
# As with start, be strict.
sub stop {
	my $self = shift;
	if ($self->is_stopped) {
		die "Attempted to stop a stationary elevator";
	}

	$self->{velocity} = 0;
}




######################################################################
# Public State

sub is_idle {
	$_[0]->is_stopped and not $_[0]->has_destination;
}

sub is_stopped {
	$_[0]->{velocity} == 0;
}

# Is the elevator at rest at a floor.
# Returns undef if not at rest at a floor
sub current_floor {
	$_[0]->is_stopped ? $_[0]->floor : undef;
}

sub has_destination {
	!! $_[0]->destinations->[0];
}

sub current_destination {
	$_[0]->destinations->[0];
}





######################################################################
# Private Methods

# Floors are located every 5 positions
sub _floor {
	$_[0]->{position} % 5;
}

# Move the elevator a tick
sub _move {
	$_[0]->{position} = $_[0]->{position} + $_[0]->{velocity};
}

1;
