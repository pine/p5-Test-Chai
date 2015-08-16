package Test::Chai::Interface::Expect;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT = qw/expect/;

use Test::Chai::Assertion;
sub Assertion { 'Test::Chai::Assertion' }

sub expect {
    my ($val, $message) = @_;
    return Assertion->new($val, $message);
}

1;
