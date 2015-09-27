package Test::Chai::Util::Length;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/length/;

sub length {
    my ($class, $obj) = @_;

    if (ref $obj eq 'ARRAY') {
        return scalar @$obj;
    }

    elsif (ref $obj eq 'HASH') {
        return scalar keys %$obj;
    }

    return length $obj;
}

1;
