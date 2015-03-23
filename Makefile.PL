use inc::Module::Install::DSL;

all_from       lib/My/Simulator.pm
requires_from  lib/My/Simulator.pm
test_requires  Test::More  0.42
test_requires  File::Spec  0.82
test_requires  Parse::CSV  2.00
