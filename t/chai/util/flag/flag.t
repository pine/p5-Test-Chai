use strict;
use warnings FATAL => 'all';
use utf8;

use t::Util;
use Test::Chai::Util::Flag qw/flag/;

subtest basic => sub {
    my $obj = {};

    is flag($obj, 'object'), undef;

    flag($obj, 'object', 0);
    is flag($obj, 'object'), 0;
    is flag($obj, 'object2'), undef;

    flag($obj, 'object2', 2);
    is flag($obj, 'object'), 0;
    is flag($obj, 'object2'), 2;

    my $array = [];
    flag($obj, 'object', $array);
    is flag($obj, 'object'), $array;
};

done_testing;
