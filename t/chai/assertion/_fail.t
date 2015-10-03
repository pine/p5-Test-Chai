use strict;
use warnings FATAL => 'all';
use utf8;

use Test::MockObject;
use Test::Mock::Guard qw/mock_guard/;

use t::Util;
use Test::Chai::Assertion;

subtest basic => sub {
    my $builder = Test::MockObject->new;
    $builder->mock(ok => sub {
        my ($self, $test, $message) = @_;
        is $test, 0, 'should be faild';
        is $message, 'message', 'should pass assertion message';
    });

    my $guard = mock_guard(
        'Test::Chai::Assertion',
        {
            builder => sub { $builder },
        });

    my $self = bless {} => 'Test::Chai::Assertion';
    $self->_fail('message');

    is $guard->call_count('Test::Chai::Assertion', 'builder'), 1,
        'should be called `call_count` method';
    ok $builder->called('ok'), 'should be called `ok` method';
};

done_testing;
