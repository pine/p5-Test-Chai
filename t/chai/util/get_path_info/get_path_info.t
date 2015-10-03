use strict;
use warnings FATAL => 'all';
use utf8;

use t::Util;
use Test::Chai::Util::GetPathInfo;

sub get_path_info { Test::Chai::Util::GetPathInfo::get_path_info(@_) }

subtest basic => sub {
    cmp_deeply
        get_path_info('[2]', [ 1, 2, 4, 8 ]),
        {
            parent => [ 1, 2, 4, 8 ],
            name   => 2,
            value  => 4,
            exists => 1,
        };

    cmp_deeply
        get_path_info('3', [ 1, 2, 4, 8 ]),
        {
            parent => [ 1, 2, 4, 8 ],
            name   => 3,
            value  => 8,
            exists => 1,
        };

    cmp_deeply
        get_path_info('foo[1].bar', { foo => [ 1, { bar => 3 }, 5 ] }),
        {
            parent => { bar => 3 },
            name   => 'bar',
            value  => 3,
            exists => 1,
        };

    cmp_deeply
        get_path_info('foo[1].bar', { foo => [ 1, { baz => 3 }, 5 ] }),
        {
            parent => { baz => 3 },
            name   => 'bar',
            value  => undef,
            exists => 0,
        };
};

done_testing;
