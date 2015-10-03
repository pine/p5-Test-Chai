use strict;
use warnings FATAL => 'all';
use utf8;

use t::Util;
use Test::Chai::Util::PathInfo;

sub _get_path_value { Test::Chai::Util::PathInfo::_get_path_value(@_) }

subtest basic => sub {
    is _get_path_value(
        [ { p => 'foo' } ], # foo
        { foo => 'foo' },
    ), 'foo';

    is _get_path_value(
        [ { i => 3 } ], # [3]
        [ 1, 2, 4, 8, 16 ],
    ), 8;

    is _get_path_value(
        [ { i => 0 }, { p => 'foo' }, { p => '1' } ], # [0].foo.1
        [ { foo => { '1' => '0_foo_1' } } ],
    ), '0_foo_1';

    is _get_path_value(
        [ { p => 'foo' }, { i => 0 } ], # foo.0
        { foo => { '0' => 'foo_0' } },
    ), 'foo_0';
};

done_testing;
