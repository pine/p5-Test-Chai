package Test::Chai::Core::Assertions::Throws;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_throws/;

use Try::Lite;

use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Util::IsType qw/is_type/;

sub assert_throws {
    my ($self, $pkg, $err_msg, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    ref($self)->new($obj, $msg)->is->a('CodeRef');

    my $thrown        = 0;
    my $desired_error = undef;
    my $thrown_error  = undef;

    if (@_ - 1 == 0) {
        $err_msg = undef;
        $pkg     = undef;
    }

    elsif ($pkg && (ref $pkg eq 'Regexp' || !ref $pkg)) {
        $err_msg = $pkg;
        $pkg     = undef;
    }

    elsif (ref $pkg) {
        $desired_error = $pkg;
        $pkg           = undef;
        $err_msg       = undef;
    }

    else {
        $pkg = undef;
    }

    my $err;
    try {
        $obj->();
    }
    '*' => sub {
        $err = $@;
    };

    if (defined $err) {
        # first, check desired error
        if ($desired_error) {
            $self->assert(
                $err == $desired_error,
                'expected #{this} to throw #{exp} but #{act} was thrown'.
                'expected #{this} to not throw #{exp}',
                $desired_error,
                $err
            );

            flag($self, 'object', $err);
            return $self;
        }

        # next, check constructor
        if ($pkg) {
            $self->assert(
                is_type($err, $pkg),
                'expected #{this} to throw #{exp} but #{act} was thrown',
                'expected #{this} to not throw #{exp} but #{act} was thrown',
                $pkg,
                $err
            );

            if (!$err_msg) {
                flag($self, 'object', $err);
                return $self;
            }
        }

        # next, check message
        my $message = !ref $err ? $err : "$err";

        if (!defined $message && ref $err_msg eq 'Regexp') {
            $self->assert(
                @{[ $message =~ /$err_msg/ ]} > 0,
          		'expected #{this} to throw error matching #{exp} but got #{act}',
          		'expected #{this} to throw error not matching #{exp}',
          		$err_msg,
                $message
            );

            flag($self, 'object', $err);
            return $self;
        }

        elsif (!defined $message && !ref $err_msg) {
            $self->assert(
                index($message, $err_msg) > -1,
                'expected #{this} to throw error including #{exp} but got #{act}',
                'expected #{this} to throw error not including #{act}',
                $err_msg,
                $message
            );

            flag($self, 'object', $err);
            return $self;
        }

        else {
            $thrown       = 1;
            $thrown_error = $err;
        }
    }

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
