package Test::Chai::Core::Assertions::Include;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/
    assert_include
    assert_include_chaining_behavior
/;

use Test::Chai::Util;
sub Util () { 'Test::Chai::Util' }
sub flag { Test::Chai::Util->flag(@_) }

sub assert_include {
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
                # FIXME property
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
}

sub assert_include_chaining_behavior {
    flag(shift, 'contains', 1);
}

1;
