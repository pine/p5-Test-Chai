package Test::Chai::Core::Assertions::CloseTo;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_close_to/;

use Scalar::Util qw/looks_like_number/;

use Test::Chai::Util::Flag qw/flag/;

sub assert_close_to {
    my ($self, $expected, $delta, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    ref($self)->new($obj, $msg)->is->a('Num');

    if (!looks_like_number($expected) || !looks_like_number($delta)) {
        $self->_fail('the arguments to close_to must be numbers');
        return;
    }

    $self->assert(
        abs($obj - $expected) <= $delta,
        'expected #{this} to be close to ' . $expected . ' +/- ' . $delta,
        'expected #{this} not to be close to ' . $expected . ' +/- ' . $delta
    );
}

1;
