package Test::Chai::Core::Assertions::Bool;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_true assert_false/;

use Scalar::Util qw/looks_like_number/;

use Test::Chai::Util::Flag qw/flag/;

sub assert_true {
    my $self = shift;
    my $obj  = flag($self, 'object');
    return $self->assert(
        looks_like_number($obj) && $obj == 1,
        'expected #{this} to be 1',
        'expected #{this} to be 0'
    );
}

sub assert_false {
    my $self = shift;
    my $obj  = flag($self, 'object');
    return $self->assert(
        looks_like_number($obj) && $obj == 0,
        'expected #{this} to be 0',
        'expected #{this} to be 1'
    );
}

1;
