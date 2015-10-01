package Test::Chai::Core::Assertions::Match;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_match/;

use Test::Chai::Util::Flag qw/flag/;

sub assert_match {
    my ($self, $re, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    return $self->assert(
        @{[ $obj =~ /$re/ ]} > 0,
        'expected #{this} to match ' . $re,
        'expected #{this} not to match ' . $re
    );
}

1;
