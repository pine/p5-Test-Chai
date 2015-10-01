package Test::Chai::Core::Assertions::Nan;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_nan/;

use Scalar::Util::Numeric qw/isnan/;

use Test::Chai::Util::Flag qw/flag/;

sub assert_nan {
    my $self = shift;
    my $obj  = flag($self, 'object');
    return $self->assert(
        isnan($obj),
        'expected #{this} to be NaN',
        'expected #{this} to be NaN'
    );
}

1;
