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

    subtest 'most(n)' => sub {
        ok expect(2)->to->be->at->most(5);
        ok expect(2)->to->be->at->most(2);
        ok expect(2)->to->not->be->at->most(1);
        ok expect(2)->to->not->be->at->most(1);
        ok expect('foo')->to->have->length->of->at->most(4);
        ok expect([ 1, 2, 3 ])->to->have->length->of->at->most(4);

        err { ok not expect(6)->to->be->at->most(5) };
        err { ok not expect(6)->to->not->be->at->most(10) };
        err { ok not expect('foo')->to->have->length->of->at->most(2) };
        err { ok not expect([ 1, 2, 3 ])->to->have->length->of->at->most(2) };
        err { ok not expect([ 1, 2 ])->to->not->have->length->of->at->most(2) };
    };

    subtest 'match(regexp)' => sub {
        ok expect('foobar')->to->match(qr/^foo/);
        ok expect('foobar')->to->matches(qr/^foo/);
        ok expect('foobar')->to->not->match(qr/^bar/);

        err { ok not expect('foobar')->to->match(qr/^bar/i) };
        err { ok not expect('foobar')->to->matches(qr/^bar/i) };
        err { ok not expect('foobar')->to->not->match(qr/^foo/i) };
    };

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
        expect('')->to->be->empty;
        expect('foo')->not->to->be->empty;
        expect([])->to->be->empty;
        expect(['foo'])->not->to->be->empty;
        expect({})->to->be->empty;
        expect({ foo => 'bar' })->not->to->be->empty;

        err { expect('')->not->to->be->empty };
        err { expect('foo')->to->be->empty };
        err { expect([])->not->to->be->empty };
        err { expect(['foo'])->to->be->empty };
        err { expect({})->not->to->be->empty };
        err { expect({ foo => 'bar' })->to->be->empty };
    };

    subtest NaN => sub {
        expect('NaN')->to->be->NaN;
        expect('foo')->not->to->be->NaN;
        expect({})->not->to->be->NaN;
        expect(4)->not->to->be->NaN;
        expect([])->not->to->be->NaN;

        err { expect(4)->to->be->NaN };
        err { expect([])->to->be->NaN };
        err { expect('foo')->to->be->NaN };
    };

    subtest 'property(name)' => sub {
        # expect('test')->to->have->property('length'); # FIXME
        # expect(4)->to->not->have->property('length');

        expect({ 'foo.bar' => 'baz' })->to->have->property('foo.bar');
        expect({ foo => { bar => 'baz' } })->to->not->have->property('foo.bar');

        my $obj = { foo => undef };
        expect($obj)->to->have->property('foo');

        expect({ 'foo.bar[]' => 'baz'})->to->have->property('foo.bar[]');

        # err { # FIXME
        #   expect('asd')->to->have->property('foo');
        # };
        err { expect({ foo => { bar => 'baz' } })->to->have->property('foo.bar') };
    };

    subtest 'deep->property(name)' => sub {
        expect({ 'foo.bar' => 'baz'})->to->not->have->deep->property('foo.bar');
        expect({ foo => { bar => 'baz' } })->to->have->deep->property('foo.bar');

        expect({ foo => [1, 2, 3] })->to->have->deep->property('foo[1]');

        # expect({ 'foo.bar[]' => 'baz'})->to->have->deep->property('foo\\.bar\\[\\]'); # FIXME

        err { expect({ 'foo.bar' => 'baz' })->to->have->deep->property('foo.bar') };
    };


    subtest 'property(name, val)' => sub {
        # expect('test').to.have.property('length', 4); # FIXME
        # expect('asd').to.have.property('constructor', String);

        my $deep_obj = {
            green => { tea => 'matcha' },
            teas  => [ 'chai', 'matcha', { tea => 'konacha' } ],
        };
        expect($deep_obj)->to->have->deep->property('green.tea', 'matcha');
        expect($deep_obj)->to->have->deep->property('teas[1]', 'matcha');
        expect($deep_obj)->to->have->deep->property('teas[2].tea', 'konacha');

        expect($deep_obj)->to->have->property('teas')
            ->that->is->an('ArrayRef')
            ->with->deep->property('[2]')
            ->that->deep->equals({ tea => 'konacha' });

        err { expect($deep_obj)->to->have->deep->property('teas[3]') };
        err { expect($deep_obj)->to->have->deep->property('teas[3]', 'bar') };
        err { expect($deep_obj)->to->have->deep->property('teas[3].tea', 'bar') };

        my $arr = [
            [ 'chai', 'matcha', 'konacha' ],
            [ { tea => 'chai' }, { tea => 'matcha' }, { tea => 'konacha' } ],
        ];
        expect($arr)->to->have->deep->property('[0][1]', 'matcha');
        expect($arr)->to->have->deep->property('[1][2].tea', 'konacha');

        err { expect($arr)->to->have->deep->property('[2][1]') };
        err { expect($arr)->to->have->deep->property('[2][1]', 'none') };
        err { expect($arr)->to->have->deep->property('[0][3]', 'none') };

        # err(function(){
        #   expect('asd').to.have.property('length', 4, 'blah');
        # }, "blah: expected 'asd' to have a property 'length' of 4, but got 3");
        #
        # err(function(){
        #   expect('asd').to.not.have.property('length', 3, 'blah');
        # }, "blah: expected 'asd' to not have a property 'length' of 3");
        #
        # err(function(){
        #   expect('asd').to.not.have.property('foo', 3, 'blah');
        # }, "blah: 'asd' has no property 'foo'");
        #
        # err(function(){
        #   expect('asd').to.have.property('constructor', Number, 'blah');
        # }, "blah: expected 'asd' to have a property 'constructor' of [Function: Number], but got [Function: String]");
    };

    subtest satisfy => sub {
        my $matcher = sub { $_[0] == 1 };

        expect(1)->to->satisfy($matcher);
        err { expect(2)->to->satisfy($matcher) };
    };

    subtest close_to => sub {
        expect(1.5)->to->be->close_to(1.0, 0.5);
        expect(10)->to->be->close_to(20, 20);
        expect(-10)->to->be->close_to(20, 30);

        err { expect(2)->to->be->close_to(1.0, 0.5) };
        err { expect(-10)->to->be->close_to(20, 29) };
        err { expect([ 1.5 ])->to->be->close_to(1.0, 0.5) };
        err { expect(1.5)->not->to->be->close_to('1.0', 0.5) };
        err { expect(1.5)->not->to->be->close_to(1.0, 1) };
    };

    # subtest 'include.members' => sub {
    #     ok expect([1, 2, 3])->to->include->members([]);
    #     ok expect([1, 2, 3])->to->include->members([3, 2]);
    #     ok expect([1, 2, 3])->to->not->include->members([8, 4]);
    #     ok expect([1, 2, 3])->to->not->include->members([1, 2, 3, 4]);
    # };

    subtest 'string()' => sub {
        expect('foobar')->to->have->string('bar');
        expect('foobar')->to->have->string('foo');
        expect('foobar')->to->not->have->string('baz');

        err { expect(3)->to->have->string('baz') };
        err { expect('foobar')->to->have->string('baz') };
        err { expect('foobar')->to->not->have->string('bar') };
    };

    subtest 'include()' => sub {
        expect([qw/foo bar/])->to->include('foo');
        expect([qw/foo bar/])->to->include('foo');
        expect([qw/foo bar/])->to->include('bar');
        expect([ 1, 2 ])->to->include(1);
        expect([qw/foo bar/])->to->not->include('baz');
        expect([qw/foo bar/])->to->not->include(1);
        expect({ a => 1, b => 2 })->to->include({ b => 2 });
        expect({ a => 1, b => 2 })->to->not->include({ b => 3 });
        expect({ a => 1, b => 2 })->to->include({ a => 1, b => 2 });
        expect({ a => 1, b => 2 })->to->not->include({ a => 1, c => 2 });

        expect([ { a => 1 }, { b => 2 } ])->to->include({ a => 1 });
        expect([ { a => 1 } ])->to->include({ a => 1 });
        expect([ { a => 1 } ])->to->not->include({ b => 1 });

        err { expect([qw/foo/])->to->include([qw/bar blah/]) };
        expect([qw/bar foo/])->to->not->include([qw/foo blah/]);
        # }, "blah: expected [ 'bar', 'foo' ] to not include 'foo'");
        #
        # err(function(){
        # expect({a:1})->to->include({b:2});
        # }, "expected { a: 1 } to have a property 'b'");
        #
        # err(function(){
        # expect({a:1,b:2})->to->not->include({b:2});
        # }, "expected { a: 1, b: 2 } to not include { b: 2 }");
        #
        # err(function(){
        # expect([{a:1},{b:2}])->to->not->include({b:2});
        # }, "expected [ { a: 1 }, { b: 2 } ] to not include { b: 2 }");
    };

    subtest 'keys(array|Object|arguments)' => sub {
        expect({ foo => 1 })->to->have->keys([qw/foo/]);
        expect({ foo => 1 })->have->keys({ foo => 6 });
        expect({ foo => 1, bar => 2 })->to->have->keys([qw/foo bar/]);
        expect({ foo => 1, bar => 2 })->to->have->keys(qw/foo bar/);
        expect({ foo => 1, bar => 2 })->have->keys({ foo => 6, bar => 7 });
        expect({ foo => 1, bar => 2, baz => 3 })->to->contain->keys(qw/foo bar/);
        expect({ foo => 1, bar => 2, baz => 3 })->to->contain->keys(qw/bar foo/);
        expect({ foo => 1, bar => 2, baz => 3 })->to->contain->keys(qw/baz/);
        expect({ foo => 1, bar => 2 })->contain->keys({ foo => 6 });
        expect({ foo => 1, bar => 2 })->contain->keys({ bar => 7 });
        expect({ foo => 1, bar => 2 })->contain->keys({ foo => 6 });

        expect({ foo => 1, bar => 2 })->to->contain->keys(qw/foo/);
        expect({ foo => 1, bar => 2 })->to->contain->keys(qw/bar foo/);
        expect({ foo => 1, bar => 2 })->to->contain->keys([qw/foo/]);
        expect({ foo => 1, bar => 2 })->to->contain->keys([qw/bar/]);
        expect({ foo => 1, bar => 2 })->to->contain->keys([qw/bar foo/]);
        expect({ foo => 1, bar => 2, baz => 3 })->to->contain->all->keys([qw/bar foo/]);

        expect({ foo => 1, bar => 2 })->to->not->have->keys('baz');
        expect({ foo => 1, bar => 2 })->to->not->have->keys('foo', 'baz');
        expect({ foo => 1, bar => 2 })->to->not->contain->keys('baz');
        expect({ foo => 1, bar => 2 })->to->not->contain->keys('foo', 'baz');
        expect({ foo => 1, bar => 2 })->to->not->contain->keys('baz', 'foo');

        expect({ foo => 1, bar => 2 })->to->have->any->keys('foo', 'baz');
        expect({ foo => 1, bar => 2 })->to->have->any->keys('foo');
        expect({ foo => 1, bar => 2 })->to->contain->any->keys('bar', 'baz');
        expect({ foo => 1, bar => 2 })->to->contain->any->keys(['foo']);
        expect({ foo => 1, bar => 2 })->to->have->all->keys(['bar', 'foo']);
        expect({ foo => 1, bar => 2 })->to->contain->all->keys(['bar', 'foo']);
        expect({ foo => 1, bar => 2 })->contain->any->keys({ 'foo' => 6 });
        expect({ foo => 1, bar => 2 })->have->all->keys({ 'foo' => 6, 'bar' => 7 });
        expect({ foo => 1, bar => 2 })->contain->all->keys({ 'bar' => 7, 'foo' => 6 });

        expect({ foo => 1, bar => 2 })->to->not->have->any->keys('baz', 'abc', 'def');
        expect({ foo => 1, bar => 2 })->to->not->have->any->keys('baz');
        expect({ foo => 1, bar => 2 })->to->not->contain->any->keys('baz');
        expect({ foo => 1, bar => 2 })->to->not->have->all->keys(['baz', 'foo']);
        expect({ foo => 1, bar => 2 })->to->not->contain->all->keys(['baz', 'foo']);
        expect({ foo => 1, bar => 2 })->not->have->all->keys({ 'baz' => 8, 'foo' => 7 });
        expect({ foo => 1, bar => 2 })->not->contain->all->keys({ 'baz' => 8, 'foo' => 7 });

        # keys required
        err { expect({ foo => 1 })->to->have->keys };
        err { expect({ foo => 1 })->to->have->keys([]) };
        err { expect({ foo => 1 })->to->not->have->keys([]) };
        err { expect({ foo => 1 })->to->contain->keys([]) };

        # mixed args msg
        err { expect({})->contain->keys(['a'], 'b') };
        err { expect({})->contain->keys({ a => 1 }, 'b') };

        err { expect({ foo => 1 })->to->have->keys(qw/bar/) };
        err { expect({ foo => 1 })->to->have->keys(qw/bar baz/) };
        err { expect({ foo => 1 })->to->have->keys(qw/foo bar baz/) };
    };


    subtest 'change' => sub {
        my $obj     = { value => 10, str => 'foo' };
        my $fn      = sub { $obj->{value} += 5 };
        my $same_fn = sub { 'foo' . 'bar' };
        my $bang_fn = sub { $obj->{str} .= '!' };

        expect($fn)->to->change($obj, 'value');
        expect($same_fn)->to->not->change($obj, 'value');
        expect($same_fn)->to->not->change($obj, 'str');
        expect($bang_fn)->to->change($obj, 'str');
    };

    subtest 'increase, decrease' => sub {
        my $obj = { value => 10 };

        my $incFn = sub { $obj->{value} += 2 };
        my $decFn = sub { $obj->{value} -= 3 };
        my $smFn  = sub { $obj->{value} += 0 };

        expect($smFn)->to->not->increase($obj, 'value');
        is $obj->{value}, 10;
        expect($decFn)->to->not->increase($obj, 'value');
        is $obj->{value}, 7;
        expect($incFn)->to->increase($obj, 'value');
        is $obj->{value}, 9;

        expect($smFn)->to->not->decrease($obj, 'value');
        is $obj->{value}, 9;
        expect($incFn)->to->not->decrease($obj, 'value');
        is $obj->{value}, 11;
        expect($decFn)->to->decrease($obj, 'value');
        is $obj->{value}, 8;
    };
};

done_testing;

