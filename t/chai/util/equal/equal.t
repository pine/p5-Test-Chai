use strict;
use warnings FATAL => 'all';
use utf8;

use t::Util;
use Test::Chai::Util::Equal qw/equal/;

subtest basic => sub {
    ok equal(undef, undef);
    ok equal(0, 0);
    ok equal(1, 1);
    ok equal('foo', 'foo');

    ok not equal(undef, 1);
    ok not equal(1, undef);
    ok not equal(0, 1);
    ok not equal(1, 0);
    ok not equal(undef, 'foo');
    ok not equal('foo', undef);
    ok not equal('foo', 'bar');
    ok not equal('bar', 'foo');

    ok not equal({}, {});
    ok not equal([], []);
    ok not equal(sub { }, sub { });
};

done_testing;
