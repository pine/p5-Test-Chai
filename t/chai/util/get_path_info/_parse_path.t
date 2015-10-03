use strict;
use warnings FATAL => 'all';
use utf8;

use t::Util;
use Test::Chai::Util::PathInfo;

sub _parse_path { Test::Chai::Util::PathInfo::_parse_path(@_) }

subtest basic => sub {
    cmp_deeply
        _parse_path('foo.bar'),
        [ { p => 'foo' }, { p => 'bar' } ];

    cmp_deeply
        _parse_path('[1]'),
        [ { i => 1 } ];

    cmp_deeply
        _parse_path('[1][2][3]'),
        [ { i => 1 }, { i => 2 }, { i => 3 } ];

    cmp_deeply
        _parse_path('foo.bar[1].baz'),
        [ { p => 'foo' }, { p => 'bar' }, { i => 1 }, { p => 'baz' } ];
};

done_testing;
