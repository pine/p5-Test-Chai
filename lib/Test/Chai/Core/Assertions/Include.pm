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
use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Assertion;
sub Util () { 'Test::Chai::Util' }

sub assert_include {
    my ($self, $val, $msg) = @_;

    # FIXME expectTypes

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
            for my $k (keys $val) {
                Test::Chai::Assertion->new($obj)->property($k, $val->{$k});
            }
            return;
        }

        my $subset = {};
        for my $k (keys $val) {
            $subset->{$k} = $obj->{$k};
        }
        $expected = Util->eql($subset, $val);
    }

    elsif (ref $obj eq 'ARRAY') {
        $expected = grep { $_ eq $val } @$obj;
    }

    elsif (ref $obj eq 'HASH') {
        $expected = grep { $_ eq $val } values %$obj;
    }

    else {
        # FIXME
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
