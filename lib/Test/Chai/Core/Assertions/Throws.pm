package Test::Chai::Core::Assertions::Throws;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_throws/;

use Test::Chai::Util::Flag qw/flag/;

sub assert_throws {
    my ($self, $str, $msg) = @_;
}

1;
