package Test::Chai::Core::Assertions;
use strict;
use warnings;
use utf8;

use Scalar::Util qw/looks_like_number/;

use Test::Chai::Assertion;
use Test::Chai::Util::Flag qw/flag/;

sub Assertion () { 'Test::Chai::Assertion' }

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

Assertion->add_property('itself', sub {
    flag(shift, 'itself', 1);
});

# -----------------------------------------------------------------------------------

use Test::Chai::Core::Assertions::An qw/assert_an/;
Assertion->add_chainable_method('an', \&assert_an);
Assertion->add_chainable_method('a',  \&assert_an);

use Test::Chai::Core::Assertions::Include qw/
    assert_include
    assert_include_chaining_behavior
/;
Assertion->add_chainable_method('include',  \&assert_include, \&assert_include_chaining_behavior);
Assertion->add_chainable_method('includes', \&assert_include, \&assert_include_chaining_behavior);
Assertion->add_chainable_method('contain',  \&assert_include, \&assert_include_chaining_behavior);
Assertion->add_chainable_method('contains', \&assert_include, \&assert_include_chaining_behavior);

use Test::Chai::Core::Assertions::Bool qw/
    assert_true
    assert_false
/;
Assertion->add_property('true',  \&assert_true);
Assertion->add_property('false', \&assert_false);

use Test::Chai::Core::Assertions::Exist qw/
    assert_ok
    assert_exist
    assert_undef
/;
Assertion->add_property('ok',        \&assert_ok);
Assertion->add_property('exist',     \&assert_exist);
Assertion->add_property('undef',     \&assert_undef);
Assertion->add_property('undefined', \&assert_undef);

use Test::Chai::Core::Assertions::Nan qw/assert_nan/;
Assertion->add_property('NaN', \&assert_nan);

use Test::Chai::Core::Assertions::Empty qw/assert_empty/;
Assertion->add_property('empty', \&assert_empty);

use Test::Chai::Core::Assertions::Equal qw/assert_equal/;
Assertion->add_method('equal',  \&assert_equal);
Assertion->add_method('equals', \&assert_equal);
Assertion->add_method('eq',     \&assert_equal);

use Test::Chai::Core::Assertions::Eql qw/assert_eql/;
Assertion->add_method('eql',  \&assert_eql);
Assertion->add_method('eqls', \&assert_eql);

use Test::Chai::Core::Assertions::Above qw/assert_above/;
Assertion->add_method('above',        \&assert_above);
Assertion->add_method('gt',           \&assert_above);
Assertion->add_method('greater_than', \&assert_above);

use Test::Chai::Core::Assertions::Least qw/assert_least/;
Assertion->add_method('least', \&assert_least);
Assertion->add_method('gte',   \&assert_least);

use Test::Chai::Core::Assertions::Below qw/assert_below/;
Assertion->add_method('below',     \&assert_below);
Assertion->add_method('lt',        \&assert_below);
Assertion->add_method('less_than', \&assert_below);

use Test::Chai::Core::Assertions::Most qw/assert_most/;
Assertion->add_method('most', \&assert_most);
Assertion->add_method('lte',  \&assert_most);

use Test::Chai::Core::Assertions::Within qw/assert_within/;
Assertion->add_method('within', \&assert_within);

use Test::Chai::Core::Assertions::InstanceOf qw/assert_instance_of/;
Assertion->add_method('instanceof',  \&assert_instance_of);
Assertion->add_method('instance_of', \&assert_instance_of);

use Test::Chai::Core::Assertions::Property qw/assert_property/;
Assertion->add_method('property', \&assert_property);

use Test::Chai::Core::Assertions::Length qw/
    assert_length
    assert_length_chain
/;
Assertion->add_method('length_of', \&assert_length);
Assertion->add_chainable_method('length', \&assert_length, \&assert_length_chain);

use Test::Chai::Core::Assertions::Match qw/assert_match/;
Assertion->add_method('match',   \&assert_match);
Assertion->add_method('matches', \&assert_match);

use Test::Chai::Core::Assertions::String qw/assert_string/;
Assertion->add_method('string', \&assert_string);

use Test::Chai::Core::Assertions::Keys qw/assert_keys/;
Assertion->add_method('keys', \&assert_keys);
Assertion->add_method('key',  \&assert_keys);

use Test::Chai::Core::Assertions::Throws qw/assert_throws/;
Assertion->add_method('throw',  \&assert_throws);
Assertion->add_method('throws', \&assert_throws);

use Test::Chai::Core::Assertions::RespondTo qw/assert_respond_to/;
Assertion->add_method('respond_to',  \&assert_respond_to);
Assertion->add_method('responds_to', \&assert_respond_to);

use Test::Chai::Core::Assertions::Satisfy qw/assert_satisfy/;
Assertion->add_method('satisfy',   \&assert_satisfy);
Assertion->add_method('satisfies', \&assert_satisfy);

use Test::Chai::Core::Assertions::CloseTo qw/assert_close_to/;
Assertion->add_method('close_to', \&assert_close_to);

use Test::Chai::Core::Assertions::Member qw/assert_member/;
Assertion->add_method('members', \&assert_member);

use Test::Chai::Core::Assertions::Change qw/assert_change/;
Assertion->add_method('change',  \&assert_change);
Assertion->add_method('changes', \&assert_change);

use Test::Chai::Core::Assertions::Increase qw/assert_increase/;
Assertion->add_chainable_method('increase',  \&assert_increase);
Assertion->add_chainable_method('increases', \&assert_increase);

use Test::Chai::Core::Assertions::Decrease qw/assert_decrease/;
Assertion->add_chainable_method('decrease',  \&assert_decrease);
Assertion->add_chainable_method('decreases', \&assert_decrease);

1;
