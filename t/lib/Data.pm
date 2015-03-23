package t::lib::Data;

use strict;
use warnings;
use File::Spec;
use Parse::CSV;
use My::Passenger;
use My::Controller;
use My::Simulator;

sub load_passengers {
	my $class = shift;
	my $file = shift;

	my $parser = Parse::CSV->new(
		file   => File::Spec->catfile("t", $file),
		names  => 1,
		filter => sub { My::Passenger->new( %$_ ) },
	);
	my @journeys = ();
	while ( my $journey = $parser->fetch ) {
		push @journeys, $journey;
	}

	return \@journeys;
}

1;
