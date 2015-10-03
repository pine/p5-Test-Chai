package Test::Chai::Core::Assertions::Include;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/
    assert_include
    assert_include_chaining_behavior
/;

use List::MoreUtils qw/any/;

use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Util::Equal qw/eql/;
use Test::Chai::Util::Type qw/is_type/;
use Test::Chai::Util::Inspect qw/inspect/;

sub assert_include {
    my ($self, $val, $msg) = @_;

    my $obj = flag($self, 'object');
    expect_types($self, $obj, [ qw/ArrayRef HashRef Value/ ]);

    flag($self, 'message', $msg) if defined $msg;
    my $expected = 0;

    if (ref $obj eq 'ARRAY' && ref $val eq 'HASH') {
        for (my $i = 0; $i < @$obj; ++$i) {
            if (eql($obj->[$i], $val)) {
                $expected = 1;
                last;
            }
        }
    }

    elsif (ref $val eq 'HASH') {
        if (!flag($self, 'negate')) {
            for my $k (keys %$val) {
                ref($self)->new($obj)->property($k, $val->{$k});
            }
            return;
        }

        my $subset = {};
        for my $k (keys $val) {
            $subset->{$k} = $obj->{$k};
        }
        $expected = eql($subset, $val);
    }

    elsif (ref $obj eq 'ARRAY') {
        $expected = grep { $_ eq $val } @$obj;
    }

    elsif (ref $obj eq 'HASH') {
        $expected = grep { $_ eq $val } values %$obj;
    }

    else {
        $expected = defined $obj && index($obj, $val) > -1;
    }

    return $self->assert(
        $expected,
        'expected #{this} to include ' . inspect($val),
        'expected #{this} to not include ' . inspect($val)
    );
}

sub assert_include_chaining_behavior {
    flag(shift, 'contains', 1);
}

sub expect_types {
    my ($self, $obj, $types) = @_;

    for my $expected (@$types) {
        return if is_type($obj, $expected);
    }

    $types = [ sort map { lc $_ } @$types ];

    my @strs;
    for (my $index = 0; $index < @$types; ++$index) {
        my $t = $types->[$index];

        my $art = (grep { $_ eq substr($t, 0, 1) } qw/a e i o u/) ? 'an' : 'a';
        my $or  = @$types > 1 && $index == @$types - 1 ? 'or ' : '';

        push @strs, $or . $art . ' ' . $t;
    }

    my $str = join(', ', @strs);
    $self->_fail('object tested must be ' . $str . ', but ' . inspect($obj) . ' given');
}

1;
