package My::Controller::EveryFloor;

# This controller represents the eight year old child approach making every
# elevator go to every floor until we run out of passengers.

use strict;
use parent 'My::Controller';

sub elevator_idle {
	my $self = shift;
	my $elevator = shift;

	if ($elevator->current_floor == $self->top_floor) {
		foreach my $floor ($self->top_floor - 1 .. 0) {
			$elevator->add_destination($floor);
		}
	} else {
		foreach my $floor (1 .. $self->top_floor) {
			$elevator->add_destination($floor);
		}
	}
}

1;
