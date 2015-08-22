use strict;
use warnings;
use utf8;

use t::Util;
use Test::MockObject;
use Test::Chai qw/expect/;

sub err (&;&$) {
    my ($code, $msg) = @_;

    my $guard = mock_guard('Test::Chai::Assertion', {
        _fail => sub {
            my ($class, $err) = @_;
            return 0;
        }
    });

    $code->();
    cmp_ok
        $guard->call_count('Test::Chai::Assertion', '_fail'), '>', 0,
        'expected test failed';
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

        err { ok not expect('test')->to->be->true };
    };

    subtest ok => sub {
        ok expect(1)->to->be->ok;
        ok expect(0)->to->not->be->ok;

        err { ok not expect('')->to->be->ok };
        err { ok not expect('test')->to->not->be->ok };
    };

    subtest false => sub {
        ok expect(0)->to->be->false;
        ok expect(1)->to->not->be->false;

        err { ok not expect('')->to->be->false };
    };

    subtest undef => sub {
        ok expect(undef)->to->be->undef;
        ok expect(0)->to->not->be->undef;

        err { ok not expect('')->to->be->undef };
    };

    subtest exist => sub {
        my $foo = 'bar';
        my $bar;

        ok expect($foo)->to->exist;
        ok expect($bar)->to->not->exist;
    };

    subtest equal => sub {
        my $foo;
        ok expect(undef)->to->equal($foo);

        err { ok not expect(undef)->to->equal(0) };
    };

    subtest typeof => sub {
        ok expect('test')->to->be->a('Str');

        err { ok not expect('test')->to->not->be->a('Str') };

        ok expect(5)->to->be->a('Int');
        ok expect('5')->to->be->a('Int');
        ok expect(1)->to->be->a('Bool');
        ok expect([])->to->be->a('ArrayRef');
        ok expect({})->to->be->a('HashRef');
        ok expect(sub {})->to->be->a('CodeRef');
        ok expect(undef)->to->be->a('Undef');

        err { ok not expect(5)->to->not->be->a('Int') };
    };

    subtest instanceof => sub {
        my $foo = Test::MockObject->new;
        $foo->set_isa('Example::Foo');

        ok expect($foo)->to->be->an->instance_of('Example::Foo');
        err { ok not expect(3)->to->be->an->instance_of('Example::Foo') };
    };

    subtest 'within(start, finish)' => sub {
        ok expect(5)->to->be->within(5, 10);
        ok expect(5)->to->be->within(3, 6);
        ok expect(5)->to->be->within(3, 5);
        ok expect(5)->to->not->be->within(1, 3);
        ok expect('foo')->to->have->length->within(2, 4);
        ok expect([ 1, 2, 3 ])->to->have->length->within(2, 4);

        err { ok not expect(5)->to->not->be->within(4, 6) };
        err { ok not expect(10)->to->be->within(50, 100) };
        err { ok not expect([ 1, 2, 3 ])->to->have->length->within(5, 7) };
    };

    subtest 'above(n)' => sub {
        ok expect(5)->to->be->above(2);
        ok expect(5)->to->be->greater_than(2);
        ok expect(5)->to->not->be->above(5);
        ok expect(5)->to->not->be->above(6);
        ok expect('foo')->to->have->length->above(2);

        err { ok not expect(5)->to->be->above(6) };
        err { ok not expect(10)->to->not->be->above(6) };
        err { ok not expect('foo')->to->have->length->above(4) };
        err { ok not expect([ 1, 2, 3 ])->to->have->length->above(4) };
    };

    subtest 'least(n)' => sub {
        ok expect(5)->to->be->at->least(2);
        ok expect(5)->to->be->at->least(5);
        ok expect(5)->to->not->be->at->least(6);
        ok expect('foo')->to->have->length->of->at->least(2);
        ok expect([ 1, 2, 3 ])->to->have->length->of->at->least(2);

        err { ok not expect(5)->to->be->at->least(6) };
        err { ok not expect(10)->to->not->be->at->least(6) };
        err { ok not expect('foo')->to->have->length->of->at->least(4) };
        err { ok not expect([ 1, 2, 3, 4 ])->to->not->have->length->of->at->least(4) };
    };

    subtest 'below(n)' => sub {
        ok expect(2)->to->be->below(5);
        ok expect(2)->to->be->less_than(5);
        ok expect(2)->to->be->lt(5);
        ok expect(2)->to->not->be->below(2);
        ok expect(2)->to->not->be->below(1);
        ok expect('foo')->to->have->length->below(4);
        ok expect([ 1, 2, 3 ])->to->have->length->below(4);

        err { ok not expect(6)->to->be->below(5) };
        err { ok not expect(6)->to->not->be->below(10) };
        err { ok not expect('foo')->to->have->length->below(2) };
        err { ok not expect([ 1, 2, 3 ])->to->have->length->below(2) };
    };

    # FIXME most
    # FIXME match

    subtest 'length(n)' => sub {
        ok expect('test')->to->have->length(4);
        ok expect('test')->to->not->have->length(3);
        ok expect([ 1, 2, 3 ])->to->have->length(3);

        err { ok not expect(4)->to->have->length(3) };
        err { ok not expect('asd')->to->not->have->length(3) };
    };

    subtest eql => sub {
        ok expect('test')->to->eql('test');
        ok expect({ foo => 'bar' })->to->eql({ foo => 'bar' });
        ok expect(1)->to->eql(1);
        ok expect('4')->to->eql(4);

        err { ok not expect(4)->to->eql(3) };
    };

    subtest 'equal(val)' => sub {
        ok expect('test')->to->equal('test');
        ok expect(1)->to->equal(1);
        ok expect('4')->to->equal(4);

        err { ok not expect(4)->to->equal(3) };
    };

    subtest 'deep.equal(val)' => sub {
        ok expect({ foo => 'bar' })->to->deep->equal({ foo => 'bar' });
        ok expect({ foo => 'bar' })->not->to->deep->equal({ foo => 'baz' });
    };

    subtest 'deep.equal(/regexp/)' => sub {
        ok expect(qr/a/)->to->deep->equal(qr/a/);
        ok expect(qr/a/)->not->to->deep->equal(qr/b/);
        ok expect(qr/a/)->not->to->deep->equal({});
        ok expect(qr/a/m)->to->deep->equal(qr/a/m);
        ok expect(qr/a/m)->not->to->deep->equal(qr/b/m);
    };

    # FIXME deep.equal(Date)

    subtest empty => sub {
        ok expect('')->to->be->empty;
        ok expect('foo')->not->to->be->empty;
        ok expect([])->to->be->empty;
        ok expect(['foo'])->not->to->be->empty;
        ok expect({})->to->be->empty;
        ok expect({ foo => 'bar' })->not->to->be->empty;

        err { ok not expect('')->not->to->be->empty };
        err { ok not expect('foo')->to->be->empty };
        err { ok not expect([])->not->to->be->empty };
        err { ok not expect(['foo'])->to->be->empty };
        err { ok not expect({})->not->to->be->empty };
        err { ok not expect({ foo => 'bar' })->to->be->empty };
    };

    subtest 'NaN' => sub {
        ok expect('NaN')->to->be->NaN;
        ok expect('foo')->not->to->be->NaN;
        ok expect({})->not->to->be->NaN;
        ok expect(4)->not->to->be->NaN;
        ok expect([])->not->to->be->NaN;

        err { ok not expect(4)->to->be->NaN };
        err { ok not expect([])->to->be->NaN };
        err { ok not expect('foo')->to->be->NaN };
    };

    subtest 'close_to' => sub {
        ok expect(1.5)->to->be->close_to(1.0, 0.5);
        ok expect(10)->to->be->close_to(20, 20);
        ok expect(-10)->to->be->close_to(20, 30);

        err { ok not expect(2)->to->be->close_to(1.0, 0.5) };
        err { ok not expect(-10)->to->be->close_to(20, 29) };
        err { ok not expect([ 1.5 ])->to->be->close_to(1.0, 0.5) };
        err { ok not expect(1.5)->not->to->be->close_to('1.0', 0.5) };
        err { ok not expect(1.5)->not->to->be->close_to(1.0, 1) };
    };

    # FIXME include

    subtest 'keys(array|Object|arguments)' => sub {
        ok expect({ foo => 1 })->to->have->keys([qw/foo/]);
        ok expect({ foo => 1 })->have->keys({ foo => 6 });
        ok expect({ foo => 1, bar => 2 })->to->have->keys([qw/foo bar/]);
        ok expect({ foo => 1, bar => 2 })->to->have->keys(qw/foo bar/);
        ok expect({ foo => 1, bar => 2 })->have->keys({ foo => 6, bar => 7 });
        ok expect({ foo => 1, bar => 2, baz => 3 })->to->contain->keys(qw/foo bar/);
        ok expect({ foo => 1, bar => 2, baz => 3 })->to->contain->keys(qw/bar foo/);
        ok expect({ foo => 1, bar => 2, baz => 3 })->to->contain->keys(qw/baz/);
        ok expect({ foo => 1, bar => 2 })->contain->keys({ foo => 6 });
        ok expect({ foo => 1, bar => 2 })->contain->keys({ bar => 7 });
        ok expect({ foo => 1, bar => 2 })->contain->keys({ foo => 6 });

        ok expect({ foo => 1, bar => 2 })->to->contain->keys(qw/foo/);
        ok expect({ foo => 1, bar => 2 })->to->contain->keys(qw/bar foo/);
        ok expect({ foo => 1, bar => 2 })->to->contain->keys([qw/foo/]);
        ok expect({ foo => 1, bar => 2 })->to->contain->keys([qw/bar/]);
        ok expect({ foo => 1, bar => 2 })->to->contain->keys([qw/bar foo/]);
        ok expect({ foo => 1, bar => 2, baz => 3 })->to->contain->all->keys([qw/bar foo/]);

        ok expect({ foo => 1, bar => 2 })->to->not->have->keys('baz');
        ok expect({ foo => 1, bar => 2 })->to->not->have->keys('foo', 'baz');
        ok expect({ foo => 1, bar => 2 })->to->not->contain->keys('baz');
        ok expect({ foo => 1, bar => 2 })->to->not->contain->keys('foo', 'baz');
        ok expect({ foo => 1, bar => 2 })->to->not->contain->keys('baz', 'foo');

        ok expect({ foo => 1, bar => 2 })->to->have->any->keys('foo', 'baz');
        ok expect({ foo => 1, bar => 2 })->to->have->any->keys('foo');
        ok expect({ foo => 1, bar => 2 })->to->contain->any->keys('bar', 'baz');
        ok expect({ foo => 1, bar => 2 })->to->contain->any->keys(['foo']);
        ok expect({ foo => 1, bar => 2 })->to->have->all->keys(['bar', 'foo']);
        ok expect({ foo => 1, bar => 2 })->to->contain->all->keys(['bar', 'foo']);
        ok expect({ foo => 1, bar => 2 })->contain->any->keys({ 'foo' => 6 });
        ok expect({ foo => 1, bar => 2 })->have->all->keys({ 'foo' => 6, 'bar' => 7 });
        ok expect({ foo => 1, bar => 2 })->contain->all->keys({ 'bar' => 7, 'foo' => 6 });

        ok expect({ foo => 1, bar => 2 })->to->not->have->any->keys('baz', 'abc', 'def');
        ok expect({ foo => 1, bar => 2 })->to->not->have->any->keys('baz');
        ok expect({ foo => 1, bar => 2 })->to->not->contain->any->keys('baz');
        ok expect({ foo => 1, bar => 2 })->to->not->have->all->keys(['baz', 'foo']);
        ok expect({ foo => 1, bar => 2 })->to->not->contain->all->keys(['baz', 'foo']);
        ok expect({ foo => 1, bar => 2 })->not->have->all->keys({ 'baz' => 8, 'foo' => 7 });
        ok expect({ foo => 1, bar => 2 })->not->contain->all->keys({ 'baz' => 8, 'foo' => 7 });

        # keys required
        err { ok not expect({ foo => 1 })->to->have->keys };
        err { ok not expect({ foo => 1 })->to->have->keys([]) };
        err { ok not expect({ foo => 1 })->to->not->have->keys([]) };
        err { ok not expect({ foo => 1 })->to->contain->keys([]) };

        # mixed args msg
        err { ok not expect({})->contain->keys(['a'], 'b') };
        err { ok not expect({})->contain->keys({ a => 1 }, 'b') };

        err { ok not expect({ foo => 1 })->to->have->keys(qw/bar/) };
        err { ok not expect({ foo => 1 })->to->have->keys(qw/bar baz/) };
        err { ok not expect({ foo => 1 })->to->have->keys(qw/foo bar baz/) };
    };
};

done_testing;

