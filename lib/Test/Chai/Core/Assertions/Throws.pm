package Test::Chai::Core::Assertions::Throws;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_throws/;

use Test::Chai::Util::Flag qw/flag/;

sub assert_throws {
    my ($self, $pkg, $err_msg, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    ref($self)->new($obj, $msg)->is->a('CodeRef');

    my $thrown        = 0;
    my $desired_error = undef;
    my $name          = undef;
    my $thrown_error  = undef;

    # if (@_ - 1 == 0) {
    #     $err_msg = undef;
    #     $pkg     = undef;
    # }
    #
    # elsif ($pkg && ref($pkg) eq 'Regexp' || !ref($pkg)) {
    #     $err_msg = $err;
    #     $pkg     = undef;
    # }

    # my $actually_got = '';
    # my $expected_thrown =
    #
    # $actually_got = ' but #{act} was thrown' if $thrown;

    # $self->assert(
    #     $throw,
    #     'expected #{this} to throw ' . $expected_thrown . $actually_got,
    #     'expected #{this} to not throw ' . $expected_thrown . $actually_got
    #     $desired_error,
    #     $thrown_error
    # );
    #
    # flag($self, 'object', $thrown_error);
}

1;
