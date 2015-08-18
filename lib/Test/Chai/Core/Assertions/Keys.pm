package Test::Chai::Core::Assertions::Keys;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_keys/;

use List::MoreUtils qw/all any/;

use Test::Chai::Util;
sub flag { Test::Chai::Util->flag(@_) }

sub assert_keys {
    my $self = shift;

    my @keys;
    my $str;
    my $obj = flag($self, 'object');
    my $ok  = 1;
    my $mixed_args_msg =
        'keys must be given single argument of ArrayRef|HashRef|String, or multiple String arguments';

    if (ref $_[0] eq 'ARRAY') {
        return $self->_fail($mixed_args_msg) if @_ > 1;
        @keys = @{ $_[0] };
    }

    elsif (ref $_[0] eq 'HASH') {
        return $self->_fail($mixed_args_msg) if @_ > 1;
        @keys = keys %{ $_[0] };
    }

    else {
        @keys = @_;
    }

    return $self->_fail('keys required') unless @keys;

    my @actual   = keys $obj;
    my @expected = @keys;
    my $len      = @keys;
    my $any      = flag($self, 'any') // 0;
    my $all      = flag($self, 'all') // 0;

    $all = 1 if !$any && !$all;

    # Has any
    if ($any) {
        my @intersection = grep { _index_of(\@actual, $_) } @expected;
        $ok = @intersection > 0;
    }

    # Has all
    if ($all) {
        $ok = all { _index_of(\@actual, $_) } @keys;

        if (!flag($self, 'negate') && !flag($self, 'contains')) {
            $ok = 0 unless @keys == @actual;
        }
    }

    # Key string
    if ($len > 1) {
        @keys = map { $_ } @keys; # FIXME
        my $last = pop @keys;
        $str = join(', ', @keys) . ', and ' . $last if $all;
        $str = join(', ', @keys) . ', or '  . $last if $any;
    }

    else {
        $str = $keys[0] // ''; # FIXME
    }

    # Form
    $str = ($len > 1 ? 'keys ' : 'key ') . $str;

    # Have / include
    $str = (flag($self, 'contains') ? 'contain ' : 'have ') . $str;

    return $self->assert(
        $ok,
        'expected #{this} to ' . $str,
        'expected #{this} to not ' . $str,
        [ sort @expected ],
        [ sort @actual ],
        1
    );
}

sub _index_of {
    my ($array, $val) = @_;
    return any { $_ eq $val } @$array;
}

1;
