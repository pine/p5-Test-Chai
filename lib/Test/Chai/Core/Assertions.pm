package Test::Chai::Core::Assertions;
use strict;
use warnings;
use utf8;

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
    Util->flag(shift, 'negate', 1);
});

Assertion->add_property('deep', sub {
    Util->flag(shift, 'deep', 1);
});

Assertion->add_property('any', sub {
    Util->flag(shift, 'any', 1);
    Util->flag(shift, 'all', 0);
});

Assertion->add_property('all', sub {
    Util->flag(shift, 'all', 0);
    Util->flag(shift, 'any', 1);
});

my $an = sub {
    my ($self, $type, $msg) = @_;

    Util->flag($self, 'message', $msg) if defined $msg;

    my $obj     = Util->flag($self, 'object');
    my $article = $type =~ /^[aeiou]/i ? 'an ' : 'a ';

    $self->assert(
        Util->matcher($type)->($obj),
        'expected #{this} to be ' . $article . $type,
        'expected #{this} not to be ' . $article . $type
    );
};

Assertion->add_chainable_method('an', $an);
Assertion->add_chainable_method('a',  $an);

# -----------------------------------------------------------------------------------

my $include_chaining_behavior = sub {
    Util->flag(shift, 'contains', 1);
};

my $include = sub {
    my ($self, $val, $msg) = @_;

    Util->flag($self, 'message', $msg) if defined $msg;

    my $obj      = Util->flag($self, 'object');
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
        if (!Util->flag($self, 'negate')) {
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
    $self->assert(
        Util->flag($self, 'object'),
        'expected #{this} to be truthy',
        'expected #{this} to be falsy'
    );
});

# -----------------------------------------------------------------------------------

Assertion->add_property('true', sub {
    my $self = shift;
    $self->assert(
        1 == Util->flag($self, 'object'),
        'expected #{this} to be 1',
        'expected #{this} to be 0'
    );
});

Assertion->add_property('false', sub {
    my $self = shift;
    $self->assert(
        0 == Util->flag($self, 'object'),
        'expected #{this} to be 0',
        'expected #{this} to be 1'
    );
});

# -----------------------------------------------------------------------------------

my $undef = sub {
    my $self = shift;
    $self->assert(
        !defined Util->flag($self, 'object'),
        'expected #{this} to be undef',
        'expected #{this} not to be undef'
    );
};

Assertion->add_property('null',      $undef);
Assertion->add_property('undef',     $undef);
Assertion->add_property('undefined', $undef);

# -----------------------------------------------------------------------------------

Assertion->add_property('NaN', sub {
    my $self = shift;
    $self->assert(
        'NaN' eq Util->flag($self, 'object'),
        'expected #{this} to be NaN',
        'expected #{this} to be NaN'
    );
});

# -----------------------------------------------------------------------------------

Assertion->add_property('exist', sub {
    my $self = shift;
    $self->assert(
        defined Util->flag($self, 'object'),
        'expected #{this} to exist',
        'expected #{this} to not exist'
    );
});

# -----------------------------------------------------------------------------------

my $empty = sub {
    my ($self) = @_;

    my $obj     = Util->flag($self, 'object');
    my $expected = 0;

    if ($obj eq 'ARRAY') {
        $expected = scalar @$obj;
    }

    elsif ($obj eq 'HASH') {
        $expected = keys %$obj == 0;
    }

    else {
        $expected = length $obj == 0;
    }

    $self->assert(
        defined Util->flag($self, 'object'),
        'expected #{this} to exist',
        'expected #{this} to not exist'
    );
};

Assertion->add_property('empty', $empty);

# -----------------------------------------------------------------------------------

my $assert_equal = sub {
    my ($self, $val, $msg) = @_;

    $msg = Util->flag($self, 'message', $msg) if defined $msg;
    my $obj = Util->flag($self, 'object');

    if (Util->flag($self, 'deep')) {
        return $self->eql($val);
    }

    else {
        $self->assert(
            $val eq $obj,
            'expected #{this} to equal #{exp}',
            'expected #{this} to not equal #{exp}',
            $val,
            $self->_obj,
            1
        );
    }
};

Assertion->add_method('equal',  $assert_equal);
Assertion->add_method('equals', $assert_equal);
Assertion->add_method('eq',     $assert_equal);

# -----------------------------------------------------------------------------------

my $assert_eql = sub {
    my ($self, $obj, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    $self->assert(
        Util->eql($obj, Util->flag($self, 'object')),
        'expected #{this} to deeply equal #{exp}',
        'expected #{this} to not deeply equal #{exp}',
        $obj,
        $self->_obj,
        1
    );
};

Assertion->add_method('eql',  $assert_equal);
Assertion->add_method('eqls', $assert_equal);

1;
