package Test::Chai::Core::Assertions::Empty;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_empty/;

use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Util::GenericLength qw/generic_length/;

sub assert_empty {
    my ($self) = @_;
    return $self->assert(
        generic_length(flag($self, 'object')) == 0,
        'expected #{this} to exist',
        'expected #{this} to not exist'
    );
}

1;
