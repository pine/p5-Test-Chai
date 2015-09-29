package Test::Chai::Interface::Expect;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT = qw/expect/;

use Test::Chai::Assertion;
use Test::Chai::AssertionError;
sub Assertion { 'Test::Chai::Assertion' }
sub AssertionError { 'Test::Chai::AssertionError' }

my $CLASS = __PACKAGE__;

sub expect {
    my ($val, $message) = @_;
    return bless {} => $CLASS if @_ == 0;
    return Assertion->new($val, $message);
}

# expect->fail(actual, expected, [message], [operator])
sub fail {
    my ($self, $actual, $expected, $message, $operator) = @_;

    my $err = AssertionError->new($message, {
        actual   => $actual,
        expected => $expected,
        operator => $operator,
    }, $CLASS.'::fail');
    return Assertion->new->_fail($err->message);
}

1;
