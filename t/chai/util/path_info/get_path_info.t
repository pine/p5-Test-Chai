use strict;
use warnings;
use utf8;

use t::Util;
use Test::Chai::Util::PathInfo;

sub get_path_info { Test::Chai::Util::PathInfo::get_path_info(@_) }

subtest basic => sub {
    cmp_deeply
        get_path_info('[2]', [ 1, 2, 4, 8 ]),
        {
            parent => [ 1, 2, 4, 8 ],
            name   => 2,
            value  => 4,
        };

    cmp_deeply
        get_path_info('3', [ 1, 2, 4, 8 ]),
        {
            parent => [ 1, 2, 4, 8 ],
            name   => 3,
            value  => 8,
        };

    cmp_deeply
        get_path_info('foo[1].bar', { foo => [ 1, { bar => 3 }, 5 ] }),
        {
            parent => { bar => 3 },
            name   => 'bar',
            value  => 3,
        };
};

done_testing;
