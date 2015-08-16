use strict;
use warnings;
use utf8;

use t::Util;
use Test::Chai qw/expect/;

sub err (&;&$) {
    my ($code, $msg) = @_;

    my $guard = mock_guard('Test::Chai::Assertion', {
        fail => sub {
            my ($class, $err) = @_;
            return 0;
        }
    });

    $code->();
    cmp_ok $guard->call_count('Test::Chai::Assertion', 'fail'), '>', 0;
}

subtest expect => sub {
    subtest VERSION => sub {
        ok expect($Test::Chai::VERSION)->to->be->a('Str');
    };

    subtest assertion => sub {
        ok expect('test')->to->be->a('Str');
        ok expect('foo')->to->equal('foo');
    };

    # FIXME
    # subtest fail => sub {
    #     expect->fail(0, 1, 'this has failed');
    # };

    subtest true => sub {
        ok expect(1)->to->be->true;
        ok expect(0)->to->not->be->true;

        err {
            ok not expect('test')->to->be->true;
        };
    };

    subtest ok => sub {
        ok expect(1)->to->be->ok;
        ok expect(0)->to->not->be->ok;

        err {
            ok not expect('')->to->be->ok;
        };

        err {
            ok not expect('test')->to->not->be->ok;
        };
    };

    subtest false => sub {
        ok expect(0)->to->be->false;
        ok expect(1)->to->not->be->false;

        err {
            ok not expect('')->to->be->false;
        };
    };

    subtest undef => sub {
        ok expect(undef)->to->be->undef;
        ok expect(0)->to->not->be->undef;

        err {
            ok not expect('')->to->be->undef;
        };
    };

    # FIXME
    # subtest exists

    subtest equal => sub {
        my $foo;
        ok expect(undef)->to->equal($foo);

        err {
            ok not expect(undef)->to->equal(0);
        };
    };

    subtest typeof => sub {
        ok expect('test')->to->be->a('Str');

        err {
           ok not expect('test')->to->not->be->a('Str');
        };

        ok expect(5)->to->be->a('Int');
        ok expect('5')->to->be->a('Int');
        ok expect(1)->to->be->a('Bool');
        ok expect([])->to->be->a('ArrayRef');
        ok expect({})->to->be->a('HashRef');
        ok expect(sub {})->to->be->a('CodeRef');
        ok expect(undef)->to->be->a('Undef');

        err {
            ok not expect(5)->to->not->be->a('Int');
        };
    };

    # FIXME
    # subtest instanceof

    subtest 'within(start, finish)' => sub {
        ok expect(5)->to->be->within(5, 10);
        ok expect(5)->to->be->within(3, 6);
        ok expect(5)->to->be->within(3, 5);
        ok expect(5)->to->not->be->within(1, 3);

        # FIXME length
        # ok expect('foo')->to->

        err {
            ok not expect(5)->to->not->be->within(4, 6);
        };

        err {
            ok not expect(10)->to->be->within(50, 100);
        };
    };


    # expect(10)->to->be->a('Int');
    # expect('abc')->to->be->a('Str');
    # expect(0)->to->not->be->ok;
    # expect(1)->to->not->be->undef;
    # expect('NaN')->to->be->NaN;
    # expect([1,2,3])->to->include(3);
    # expect([])->to->be->empty;
    # expect('abc')->to->equal('abc');
    # expect([])->to->be->empty;
    # expect(10)->to->be->above(5);
};

done_testing;

