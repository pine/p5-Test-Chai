package Test::Chai::Core::Assertions::Least;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_least/;

use Test::Chai::Util;
sub Util () { 'Test::Chai::Util' }
sub flag    { Test::Chai::Util->flag(@_) }

sub assert_least {
    my ($self, $n, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    if (flag($self, 'do_length')) {
        my $len = Util->length($obj);
        return $self->assert(
            $len >= $n,
            'expected #{this} to have a length a least #{exp} but got #{act}',
            'expected #{this} to not have a length bellow #{exp}',
            $n,
            $len
        );
    }

    else {
        return $self->assert(
            $obj >= $n,
            'expected #{this} to be at least ' . $n,
            'expected #{this} to be below ' . $n
        );
    }
}

1;
