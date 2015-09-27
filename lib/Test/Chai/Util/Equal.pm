package Test::Chai::Util::Equal;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/equal/;

sub equal {
    my ($lhs, $rhs) = @_;

    my $equals       = defined $lhs && defined $rhs && $lhs eq $rhs;
    my $equals_undef = !defined $lhs && !defined $rhs; # undef == undef

    return $equals || $equals_undef;
}

1;
