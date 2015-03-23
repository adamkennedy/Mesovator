package Elevator;

use 5.010;
use strict;
use warnings;
use Object::Tiny qw{
	velocity
	passengers
	detinations
};

our $VERSION = '0.01';

sub new {
	my $self = shift->SUPER::new(@_);

	# State variables
	$self->{velocity}     = 0;
	$self->{position}     = 0;
	$self->{passengers}   = [];
	$self->{destinations} = [];

	return $self;
}

sub is_stopped {
	$_[0]->velocity == 0;
}

# Floors are located every 5 positions
sub _floor {
	$_[0]->position % 5;
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

1;
