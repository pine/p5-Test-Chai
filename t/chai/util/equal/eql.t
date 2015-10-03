use strict;
use warnings FATAL => 'all';
use utf8;

use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use Test::Chai::Util::Equal qw/eql/;

subtest basic => sub {
    my $guard = mock_guard(
        'Test::Chai::Util::Equal',
        {
            eq_deeply => sub {
                is shift, 'foo', 'should equal the first argument';
                is shift, 'bar', 'should equal the second argument';
            },
        });

    eql('foo', 'bar');

    is
        $guard->call_count('Test::Chai::Util::Equal', 'eq_deeply'),
        1,
        'should call mock once';
};

done_testing;
