package My::Lobby;

use 5.010;
use strict;
use warnings;
use Params::Util ':ALL';
use Object::Tiny qw{
	position
	floor
	passengers
	call_up
	call_down
};

our $VERSION = '0.01';

sub new {
	my $self = shift->SUPER::new(@_);

	unless (defined _NONNEGINT($self->floor)) {
		die "Missing or invalid floor";
	}

	# Bakes the floor to position assumption into two places,
	# see My::Elevator as well. This is terrible practice but I'm
	# in an unnatural hurry. Will fix later.
	$self->{position}   = $self->floor * 5;

	# State
	$self->{passengers} = [];
	$self->{call_up}    = 0;
	$self->{call_down}  = 0;

	return $self;
}

1;
