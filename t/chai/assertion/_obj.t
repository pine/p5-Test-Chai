use strict;
use warnings FATAL => 'all';
use utf8;

use t::Util;
use Test::Chai::Assertion;

subtest basic => sub {
    my $self = bless {} => 'Test::Chai::Assertion';

    is $self->_obj, undef;

    $self->_obj('object');
    is $self->_obj, 'object';
};

done_testing;
