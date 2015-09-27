package Test::Chai::Util::Flag;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/flag/;

sub flag {
    my ($obj, $key, $value) = @_;

    my $flags = $obj->{__flags};
    $flags = $obj->{__flags} = {} unless defined $flags;

    if (@_ == 3) {
        $flags->{$key} = $value;
        return undef;
    }

    else {
        return $flags->{$key};
    }
}

1;
