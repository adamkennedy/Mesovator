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

sub passenger_arrives {
	my $self      = shift;
	my $passenger = shift;

	# Null Implementation
}


1;
