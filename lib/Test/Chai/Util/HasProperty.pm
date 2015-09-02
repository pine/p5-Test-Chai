package Test::Chai::Util::HasProperty;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/has_property/;

use Scalar::Util qw/looks_like_number blessed/;
use List::MoreUtils qw/any/;

sub has_property {
    my ($name, $obj) = @_;

    return 0 unless defined $obj;

    if (ref $obj eq 'ARRAY') {
        return 0 unless looks_like_number($name);
        return 1 if 0 <= $name && $name < @$obj;
        return 0;
    }

    elsif (ref $obj eq 'HASH' || blessed($obj)) {
        return 0 unless defined $name;
        return 1 if any { $_ eq $name } keys(%$obj);
        return 0;
    }

    return 0 <= $name && $name < length $obj;
}

1;
