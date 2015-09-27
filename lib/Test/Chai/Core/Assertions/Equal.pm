package Test::Chai::Core::Assertions::Equal;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_equal/;

use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Util::Equal qw/equal/;

sub assert_equal {
    my ($self, $val, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    if (flag($self, 'deep')) {
        return $self->eql($val);
    }

    return $self->assert(
        equal($val, $obj),
        'expected #{this} to equal #{exp}',
        'expected #{this} to not equal #{exp}',
        $val,
        $self->_obj,
        1
    );
}

1;
