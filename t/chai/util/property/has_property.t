use strict;
use warnings FATAL => 'all';
use utf8;

use Test::MockObject;

use t::Util;
use Test::Chai::Util::Property qw/has_property/;

subtest basic => sub {
    subtest undef => sub {
        is has_property(0, undef), 0;
        is has_property('a', undef), 0;
        is has_property(undef, undef), 0;
    };

    subtest number => sub {
        is has_property(0, 1), 1;
        is has_property(1, 1), 0;
    };

    subtest array => sub {
        is has_property(0, []), 0;
        is has_property(0, [ 0 ]), 1;
        is has_property(0, [ undef ]), 1;
        is has_property(0, [ 0, 1, 2 ]), 1;
        is has_property(-1, [ 0, 1, 2 ]), 0;
        is has_property(3, [ 0, 1, 2 ]), 0;
        is has_property(undef, [ 0, 1, 2 ]), 0;
    };

    subtest hash => sub {
        is has_property('a', {}), 0;
        is has_property('a', { b => 1 }), 0;
        is has_property('a', { a => 1 }), 1;
        is has_property('a', { a => undef }), 1;
        is has_property('a', { a => 1, b => 1 }), 1;
        is has_property(undef, { a => 1, b => 1 }), 0;
        is has_property(0, { '0' => 1 }), 1;
        is has_property(0, { '0' => undef }), 1;
        is has_property(undef, { '0' => undef }), 0;
    };

    subtest blessed => sub {
        my $mock = Test::MockObject->new;
        $mock->set_isa('Example::Mock');

        $mock->{'_____valid_property_0'} = 0;
        $mock->{'_____valid_property_1'} = undef;

        is has_property('_____invalid_property', $mock), 0;
        is has_property('_____valid_property_0', $mock), 1;
        is has_property('_____valid_property_1', $mock), 1;
    };
};

done_testing;
