package Test::Chai::Util::ObjDisplay;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/obj_display/;

our $TRUNCATE_THRESHOLD = 40;

use Test::Chai::Util::Inspect qw/inspect/;

sub obj_display {
    my $obj = shift;

    my $str = inspect($obj);

    if (ref $obj eq 'CODE') {
        return '[Code]';
    }

    if (length $str >= $TRUNCATE_THRESHOLD) {
        if (ref $obj eq 'ARRAY') {
            return '[ Array('.@$obj.') ]';
        }

        elsif (ref $obj eq 'HASH') {
            my @keys = sort keys %$obj;
            my $kstr = @keys > 2 ?
                join(', ', @keys[0..1]).', ...' : join(', ', @keys);
            return '{ Hash ('.$kstr.') }';
        }

        else {
            return $str;
        }
    }

    else {
        return $str;
    }
}

1;
