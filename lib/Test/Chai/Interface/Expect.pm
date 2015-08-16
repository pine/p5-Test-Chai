package Test::Chai::Interface::Expect;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT = qw/expect/;

use Test::Chai::Assertion;
sub Assertion { 'Test::Chai::Assertion' }

my $CLASS = __PACKAGE__;

sub expect {
    my ($val, $message) = @_;
    return bless {} => $CLASS if @_ == 0;
    return Assertion->new($val, $message);
}

# expect->fail(actual, expected, [message], [operator])
sub fail {
    # FIXME
}

1;
