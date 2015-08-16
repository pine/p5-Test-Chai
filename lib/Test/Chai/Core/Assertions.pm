package Test::Chai::Core::Assertions;
use strict;
use warnings;
use utf8;

use Scalar::Util qw/looks_like_number/;

sub Assertion { 'Test::Chai::Assertion' }
sub Util      { 'Test::Chai::Util'      }

sub flag { Util->flag(@_) }

do {
    Assertion->add_property($_, sub { shift })
} for qw/
    to be been
    is and has have
    with that which at
    of same
/;

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

my $an = sub {
    my ($self, $type, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;

    my $obj     = flag($self, 'object');
    my $article = $type =~ /^[aeiou]/i ? 'an ' : 'a ';

    return $self->assert(
        Util->matcher($type)->($obj),
        'expected #{this} to be ' . $article . $type,
        'expected #{this} not to be ' . $article . $type
    );
};

Assertion->add_chainable_method('an', $an);
Assertion->add_chainable_method('a',  $an);

# -----------------------------------------------------------------------------------

my $include_chaining_behavior = sub {
    flag(shift, 'contains', 1);
};

my $include = sub {
    my ($self, $val, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;

    my $obj      = flag($self, 'object');
    my $expected = 0;

    if (ref $obj eq 'ARRAY' && ref $val eq 'HASH') {
        for my $i (keys $obj) {
            if (Util->eql($obj->[$i], $val)) {
                $expected = 1;
                last;
            }
        }
    }

    elsif (ref $val eq 'HASH') {
        if (!flag($self, 'negate')) {
            for my $i (keys $val) {
                # FIXME
            }
        }

        my $subset = {};
        for my $k (keys $val) {
            $subset->[$k] = $obj->[$k];
        }
        $expected = Util->eql($subset, $val);
    }

    elsif (ref $obj eq 'ARRAY') {
        $expected = grep { $_ eq $val } @$obj;
    }

    elsif (ref $obj eq 'HASH') {
        $expected = grep { $_ eq $val } values %$obj;
    }

    $self->assert(
        $expected,
        'expected #{this} to include ' . $val, # FIXME
        'expected #{this} to not include ' . $val
    );
};

Assertion->add_chainable_method('include',  $include, $include_chaining_behavior);
Assertion->add_chainable_method('includes', $include, $include_chaining_behavior);
Assertion->add_chainable_method('contain',  $include, $include_chaining_behavior);
Assertion->add_chainable_method('contains', $include, $include_chaining_behavior);

# -----------------------------------------------------------------------------------

Assertion->add_property('ok', sub {
    my $self = shift;
    my $obj  = flag($self, 'object');
    return $self->assert(
        $obj,
        'expected #{this} to be truthy',
        'expected #{this} to be falsy'
    );
});

# -----------------------------------------------------------------------------------

Assertion->add_property('true', sub {
    my $self = shift;
    my $obj  = flag($self, 'object');
    return $self->assert(
        looks_like_number($obj) && $obj == 1,
        'expected #{this} to be 1',
        'expected #{this} to be 0'
    );
});

Assertion->add_property('false', sub {
    my $self = shift;
    my $obj  = flag($self, 'object');
    return $self->assert(
        looks_like_number($obj) && $obj == 0,
        'expected #{this} to be 0',
        'expected #{this} to be 1'
    );
});

# -----------------------------------------------------------------------------------

my $undef = sub {
    my $self = shift;
    return $self->assert(
        !defined flag($self, 'object'),
        'expected #{this} to be undef',
        'expected #{this} not to be undef'
    );
};

Assertion->add_property('undef',     $undef);
Assertion->add_property('undefined', $undef);

# -----------------------------------------------------------------------------------

Assertion->add_property('NaN', sub {
    my $self = shift;
    $self->assert(
        'NaN' eq flag($self, 'object'),
        'expected #{this} to be NaN',
        'expected #{this} to be NaN'
    );
});

# -----------------------------------------------------------------------------------

Assertion->add_property('exist', sub {
    my $self = shift;
    $self->assert(
        defined flag($self, 'object'),
        'expected #{this} to exist',
        'expected #{this} to not exist'
    );
});

# -----------------------------------------------------------------------------------

my $empty = sub {
    my ($self) = @_;

    $self->assert(
        Util->length(flag($self, 'object')) == 0,
        'expected #{this} to exist',
        'expected #{this} to not exist'
    );
};

Assertion->add_property('empty', $empty);

# -----------------------------------------------------------------------------------

my $assert_equal = sub {
    my ($self, $val, $msg) = @_;

    $msg = flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    if (flag($self, 'deep')) {
        return $self->eql($val);
    }

    my $equals       = defined $val && defined $obj && $val eq $obj;
    my $equals_undef = !defined $val && !defined $obj; # undef == undef

    return $self->assert(
        $equals || $equals_undef,
        'expected #{this} to equal #{exp}',
        'expected #{this} to not equal #{exp}',
        $val,
        $self->_obj,
        1
    );
};

Assertion->add_method('equal',  $assert_equal);
Assertion->add_method('equals', $assert_equal);
Assertion->add_method('eq',     $assert_equal);

# -----------------------------------------------------------------------------------

my $assert_eql = sub {
    my ($self, $obj, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    $self->assert(
        Util->eql($obj, flag($self, 'object')),
        'expected #{this} to deeply equal #{exp}',
        'expected #{this} to not deeply equal #{exp}',
        $obj,
        $self->_obj,
        1
    );
};

Assertion->add_method('eql',  $assert_equal);
Assertion->add_method('eqls', $assert_equal);

# -----------------------------------------------------------------------------------

sub assert_above {
    my ($self, $n, $msg) = @_;

    flag($self, 'message', $msg);
    my $obj = flag($self, 'object');

    if (flag($self, 'do_length')) {
        my $len = Util->length($obj);
        $self->assert(
            $len > $n,
            'expected #{this} to have a length above #{exp} but got #{act}',
            'expected #{this} to not have a length above #{exp}',
            $n,
            $len
        );
    }

    else {
        $self->assert(
            $obj > $n,
            'expected #{this} to be above ' . $n,
            'expected #{this} to be at most ' . $n
        );
    }
};

Assertion->add_method('above',        \&assert_above);
Assertion->add_method('gt',           \&assert_above);
Assertion->add_method('greater_than', \&assert_above);

# -----------------------------------------------------------------------------------

sub assert_least {
    my ($self, $n, $msg) = @_;

    flag($self, 'message', $msg);
    my $obj = flag($self, 'object');

    if (flag($self, 'do_length')) {
        my $len = Util->length($obj);
        $self->assert(
            $len >= $n,
            'expected #{this} to have a length a least #{exp} but got #{act}',
            'expected #{this} to not have a length bellow #{exp}',
            $n,
            $len
        );
    }

    else {
        $self->assert(
            $obj >= $n,
            'expected #{this} to be at least ' . $n,
            'expected #{this} to be below ' . $n
        );
    }
}

Assertion->add_method('least', \&assert_least);
Assertion->add_method('gte',   \&assert_least);

# -----------------------------------------------------------------------------------

# FIXME assertBelow
# FIXME assertMost

# -----------------------------------------------------------------------------------

sub within {
    my ($self, $start, $finish, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj   = flag($self, 'object');
    my $range = $start . '..' . $finish;

    if (flag($self, 'do_length')) {
        my $len = Util->length($obj);
        return $self->assert(
            $len >= $start && $len < $finish,
            'expected #{this} to have a length within ' . $range,
            'expected #{this} to not have a length within ' . $range
        );
    }

    else {
        return $self->assert(
            $obj >= $start && $obj <= $finish,
            'expected #{this} to be within ' . $range,
            'expected #{this} to not be within ' . $range
        );
   }
}

Assertion->add_method('within', \&within);


1;
