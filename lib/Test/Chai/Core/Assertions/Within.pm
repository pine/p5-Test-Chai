package Test::Chai::Core::Assertions::Within;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_within/;

use Test::Chai::Util;
sub Util () { 'Test::Chai::Util' }
sub flag    { Test::Chai::Util->flag(@_) }

sub assert_within {
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

1;
