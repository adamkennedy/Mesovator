package My::Controller::NaiveRoundRobin;

# This controller implements the naive round robin algorithm used to test the
# elevator saga simulator.

# Rules:
# 1. Go to the ground floor when you have nothing to do.
# 2. Add the destination for anyone that gets in the elevator.
# 3. Regardless of whether they want to go up or down dispatch an elevator
#    to people in naive round robin fashion.

use strict;
use parent 'My::Controller';

sub new {
	my $self = shift->SUPER::new(@_);

	$self->{rotator} = 0;

	return $self;
}

# 1. Go to the ground floor when you have nothing to do.
sub elevator_idle {
	my $self     = shift;
	my $elevator = shift;

	$elevator->add_destination(0);
}

# 2. Add the destination for anyone that gets in the elevator.
sub elevator_floor_button_pressed {
	my $self     = shift;
	my $elevator = shift;
	my $floor    = shift;

	$elevator->add_destination($floor);
}

# 3. Regardless of whether they want to go up or down...
sub lobby_up_button_pressed {
	$_[0]->_floor_button_pressed($_[1]);
}

# 3. Regardless of whether they want to go up or down...
sub lobby_down_button_pressed {
	$_[0]->_floor_button_pressed($_[1]);
}

# 3. Regardless of whether they want to go up or down dispatch an elevator
#    to people in naive round robin fashion.
sub lobby_button_pressed {
	my $self = shift;
	my $floor = shift;

	$self->simulator->elevator(++$self->{rotator} % $self->floors)->add_destination($floor);
}

1;
