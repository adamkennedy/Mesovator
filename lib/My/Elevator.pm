package Elevator;

use 5.010;
use strict;
use warnings;
use Object::Tiny qw{
	
};

our $VERSION = '0.01';

sub new {
	my $self = shift->SUPER::new(@_);

	# State variables
	$self->{passengers}   = [];
	$self->{destinations} = [];

	return $self;
}

1;
