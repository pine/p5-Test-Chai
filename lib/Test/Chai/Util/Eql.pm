package Test::Chai::Util::Eql;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/eql/;

use Test::Deep::NoTest qw/eq_deeply/;

sub eql {
    return eq_deeply(@_);
}

1;
