#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use Test::More;

use_ok("My::Simulator");
use_ok("My::Elevator");
use_ok("My::Passenger");
use_ok("My::Lobby");
use_ok("My::Controller");
use_ok("My::Controller::EveryFloor");
use_ok("My::Controller::NaiveRoundRobin");

done_testing();
