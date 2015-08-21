package Test::Chai::Core::Assertions::Equal;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_equal/;

use Test::Chai::Util;
sub flag { Test::Chai::Util->flag(@_) }

sub assert_equal {
    my ($self, $val, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    if (flag($self, 'deep')) {
        return $self->eql($val);
    }

    my $equals       = defined $val && defined $obj && $val eq $obj;
    my $equals_undef = !defined $val && !defined $obj; # undef == undef

    return $self->assert(
        $equals || $equals_undef,
        'expected #{this} to equal #{exp}',
        'expected #{this} to not equal #{exp}',
        $val,
        $self->_obj,
        1
    );
}

1;
