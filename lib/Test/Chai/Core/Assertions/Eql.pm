package Test::Chai::Core::Assertions::Eql;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_eql/;

use Test::Chai::Util::Equal qw/eql/;
use Test::Chai::Util::Flag qw/flag/;

sub assert_eql {
    my ($self, $obj, $msg) = @_;
    flag($self, 'message', $msg) if defined $msg;
    return $self->assert(
        eql($obj, flag($self, 'object')),
        'expected #{this} to deeply equal #{exp}',
        'expected #{this} to not deeply equal #{exp}',
        $obj,
        $self->_obj,
        1
    );
}

1;
