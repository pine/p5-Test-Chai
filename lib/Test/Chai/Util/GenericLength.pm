package Test::Chai::Util::GenericLength;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/generic_length/;

sub generic_length {
    my $obj = shift;

    if (ref $obj eq 'ARRAY') {
        return scalar @$obj;
    }

    elsif (ref $obj eq 'HASH') {
        return scalar keys %$obj;
    }

    return length $obj;
}

1;
