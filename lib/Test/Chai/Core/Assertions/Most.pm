package Test::Chai::Core::Assertions::Most;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_most/;

use Test::Chai::Util;
sub Util () { 'Test::Chai::Util' }
sub flag    { Test::Chai::Util->flag(@_) }

sub assert_most {
    my ($self, $n, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    if (flag($self, 'do_length')) {
        my $len = Util->length($obj);
        return $self->assert(
            $len <= $n,
            'expected #{this} to have a length at most #{exp} but got #{act}',
            'expected #{this} to have a length above #{exp}',
            $n,
            $len
        );
    }

    else {
        return $self->assert(
            $obj <= $n,
            'expected #{this} to be at most ' . $n,
            'expected #{this} to be above ' . $n
        );
    }
}

1;