package Test::Chai::Core::Assertions::Exist;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/
    assert_ok
    assert_exist
    assert_undef
/;

use Test::Chai::Util::Flag qw/flag/;

sub assert_ok {
    my $self = shift;
    my $obj  = flag($self, 'object');
    return $self->assert(
        $obj,
        'expected #{this} to be truthy',
        'expected #{this} to be falsy'
    );
}

sub assert_exist {
    my $self = shift;
    return $self->assert(
        defined flag($self, 'object'),
        'expected #{this} to exist',
        'expected #{this} to not exist'
    );
}

sub assert_undef {
    my $self = shift;
    return $self->assert(
        !defined flag($self, 'object'),
        'expected #{this} to be undef',
        'expected #{this} not to be undef'
    );
}

1;
