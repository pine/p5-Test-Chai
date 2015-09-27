package Test::Chai::Core::Assertions;
use strict;
use warnings;
use utf8;

use Scalar::Util qw/looks_like_number/;
use Scalar::Util::Numeric qw/isnan/;


sub Util ()      { 'Test::Chai::Util'      }
sub Assertion () { 'Test::Chai::Assertion' }
sub flag         { Util->flag(@_)          }

# -----------------------------------------------------------------------------------

do {
    Assertion->add_property($_, sub { shift })
} for qw/
    to be been
    is and has have
    with that which at
    of same
/;

# -----------------------------------------------------------------------------------

Assertion->add_property('not', sub {
    flag(shift, 'negate', 1);
});

Assertion->add_property('deep', sub {
    flag(shift, 'deep', 1);
});

Assertion->add_property('any', sub {
    flag(shift, 'any', 1);
    flag(shift, 'all', 0);
});

Assertion->add_property('all', sub {
    flag(shift, 'all', 0);
    flag(shift, 'any', 1);
});

# -----------------------------------------------------------------------------------

sub assert_an {
    my ($self, $type, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;

    my $obj     = flag($self, 'object');
    my $article = $type =~ /^[aeiou]/i ? 'an ' : 'a ';

    return $self->assert(
        Util->matcher($type)->($obj),
        'expected #{this} to be ' . $article . $type,
        'expected #{this} not to be ' . $article . $type
    ) ? undef : 0;
}

Assertion->add_chainable_method('an', \&assert_an);
Assertion->add_chainable_method('a',  \&assert_an);

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::Include qw/
    assert_include
    assert_include_chaining_behavior
/;

Assertion->add_chainable_method('include',  \&assert_include, \&assert_include_chaining_behavior);
Assertion->add_chainable_method('includes', \&assert_include, \&assert_include_chaining_behavior);
Assertion->add_chainable_method('contain',  \&assert_include, \&assert_include_chaining_behavior);
Assertion->add_chainable_method('contains', \&assert_include, \&assert_include_chaining_behavior);

# -----------------------------------------------------------------------------------

sub assert_ok {
    my $self = shift;
    my $obj  = flag($self, 'object');
    return $self->assert(
        $obj,
        'expected #{this} to be truthy',
        'expected #{this} to be falsy'
    );
}

Assertion->add_property('ok', \&assert_ok);

# -----------------------------------------------------------------------------------

sub assert_true {
    my $self = shift;
    my $obj  = flag($self, 'object');
    return $self->assert(
        looks_like_number($obj) && $obj == 1,
        'expected #{this} to be 1',
        'expected #{this} to be 0'
    );
}

Assertion->add_property('true', \&assert_true);

# -----------------------------------------------------------------------------------

sub assert_false {
    my $self = shift;
    my $obj  = flag($self, 'object');
    return $self->assert(
        looks_like_number($obj) && $obj == 0,
        'expected #{this} to be 0',
        'expected #{this} to be 1'
    );
}

Assertion->add_property('false', \&assert_false);

# -----------------------------------------------------------------------------------

sub assert_undef {
    my $self = shift;
    return $self->assert(
        !defined flag($self, 'object'),
        'expected #{this} to be undef',
        'expected #{this} not to be undef'
    );
}

Assertion->add_property('undef',     \&assert_undef);
Assertion->add_property('undefined', \&assert_undef);

# -----------------------------------------------------------------------------------

sub assert_nan {
    my $self = shift;
    my $obj  = flag($self, 'object');
    return $self->assert(
        isnan($obj),
        'expected #{this} to be NaN',
        'expected #{this} to be NaN'
    );
}

Assertion->add_property('NaN', \&assert_nan);

# -----------------------------------------------------------------------------------

sub assert_exist {
    my $self = shift;
    return $self->assert(
        defined flag($self, 'object'),
        'expected #{this} to exist',
        'expected #{this} to not exist'
    );
}

Assertion->add_property('exist', \&assert_exist);

# -----------------------------------------------------------------------------------

sub assert_empty {
    my ($self) = @_;
    return $self->assert(
        Util->length(flag($self, 'object')) == 0,
        'expected #{this} to exist',
        'expected #{this} to not exist'
    );
}

Assertion->add_property('empty', \&assert_empty);

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::Equal qw/assert_equal/;

Assertion->add_method('equal',  \&assert_equal);
Assertion->add_method('equals', \&assert_equal);
Assertion->add_method('eq',     \&assert_equal);

# -----------------------------------------------------------------------------------

sub assert_eql {
    my ($self, $obj, $msg) = @_;
    flag($self, 'message', $msg) if defined $msg;
    return $self->assert(
        Util->eql($obj, flag($self, 'object')),
        'expected #{this} to deeply equal #{exp}',
        'expected #{this} to not deeply equal #{exp}',
        $obj,
        $self->_obj,
        1
    );
}

Assertion->add_method('eql',  \&assert_eql);
Assertion->add_method('eqls', \&assert_eql);

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::Above qw/assert_above/;

Assertion->add_method('above',        \&assert_above);
Assertion->add_method('gt',           \&assert_above);
Assertion->add_method('greater_than', \&assert_above);

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::Least qw/assert_least/;

Assertion->add_method('least', \&assert_least);
Assertion->add_method('gte',   \&assert_least);

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::Below qw/assert_below/;

Assertion->add_method('below',     \&assert_below);
Assertion->add_method('lt',        \&assert_below);
Assertion->add_method('less_than', \&assert_below);

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::Most qw/assert_most/;

Assertion->add_method('most', \&assert_most);
Assertion->add_method('lte',  \&assert_most);

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::Within qw/assert_within/;

Assertion->add_method('within', \&assert_within);

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::InstanceOf qw/assert_instance_of/;

Assertion->add_method('instanceof',  \&assert_instance_of);
Assertion->add_method('instance_of', \&assert_instance_of);

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::Property qw/assert_property/;

Assertion->add_method('property', \&assert_property);

# -----------------------------------------------------------------------------------

sub assert_length_chain {
    flag(shift, 'do_length', 1);
}

sub assert_length {
    my ($self, $n, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');
    my $len = Util->length($obj);

    return $self->assert(
        $len == $n,
        'expected #{this} to have a length of #{exp} but got #{act}',
        'expected #{this} to not have a length of #{act}',
        $n,
        $len
    );
}

Assertion->add_chainable_method('length', \&assert_length, \&assert_length_chain);
Assertion->add_method('length_of', \&assert_length);

# -----------------------------------------------------------------------------------

sub assert_match {
    my ($self, $re, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    return $self->assert(
        @{[ $obj =~ /$re/ ]} > 0,
        'expected #{this} to match ' . $re,
        'expected #{this} not to match ' . $re
    );
}

Assertion->add_method('match',   \&assert_match);
Assertion->add_method('matches', \&assert_match);

# -----------------------------------------------------------------------------------

sub assert_string {
    my ($self, $str, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    Assertion->new($obj, $msg)->is->a('Str');

    return $self->assert(
        index($obj, $str) > -1,
        'expected #{this} to contain ' . $str, # FIXME inspect
        'expected #{this} to not contain ' . $str
    );
}

Assertion->add_method('string', \&assert_string);

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::Keys qw/assert_keys/;

Assertion->add_method('keys', \&assert_keys);
Assertion->add_method('key',  \&assert_keys);

# FIXME throws
# FIXME respondTo

# -----------------------------------------------------------------------------------

Assertion->add_property('itself', sub {
    flag(shift, 'itself', 1);
});

# -----------------------------------------------------------------------------------

sub assert_satisfy {
    my ($self, $matcher, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj    = flag($self, 'object');
    my $negate = flag($self, 'negate');
    my $result = $matcher->($obj);

    return $self->assert(
        $result,
        'expected #{this} to satisfy ' . Util->obj_display($matcher),
        'expected #{this} to not satisfy' . Util->obj_display($matcher),
        $negate ? 0 : 1,
        $result
    );
}

Assertion->add_method('satisfy',   \&assert_satisfy);
Assertion->add_method('satisfies', \&assert_satisfy);

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::CloseTo qw/assert_close_to/;

Assertion->add_method('close_to', \&assert_close_to);

# -----------------------------------------------------------------------------------

# FIXME members
# FIXME change

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::Increase qw/assert_increase/;

Assertion->add_chainable_method('increase',  \&assert_increase);
Assertion->add_chainable_method('increases', \&assert_increase);

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::Decrease qw/assert_decrease/;

Assertion->add_chainable_method('decrease',  \&assert_decrease);
Assertion->add_chainable_method('decreases', \&assert_decrease);

1;
