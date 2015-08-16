package Test::Chai::Assertion;
use strict;
use warnings;
use utf8;

use parent qw/Test::Builder::Module/;

use Test::Chai::AssertionError;
use Test::Chai::Config;

# alias
sub Util ()           { 'Test::Chai::Util'           }
sub Config ()         { 'Test::Chai::Config'         }
sub AssertionError () { 'Test::Chai::AssertionError' }

sub flag { Util->flag(@_) }


sub new {
    my ($class, $obj, $msg, $stack) = @_;

    my $self = {};
    bless $self => $class;

    # Util->flag($self, 'ssfi' FIXME
    Util->flag($self, 'object',  $obj);
    Util->flag($self, 'message', $msg);

    return $self;
}

sub add_property {
    Util->add_property(@_);
}

sub add_method {
    Util->add_method(@_);
}

sub add_chainable_method {
    Util->add_chainable_method(@_);
}

sub assert {
    my $self = shift;
    my ($expr, $msg, $negateMsg, $expected, $_actual, $show_diff) = @_;

    my $ok = Util->test($self, [@_]);
    $show_diff = 0 if defined $show_diff && $show_diff != 1;
    $show_diff = 0 if Config->show_diff != 1;

    if (!$ok) {
        my $msg    = Util->get_message($self, [@_]);
        my $actual = Util->get_actual($self, [@_]);

        my $err = AssertionError->new($msg, {
            actual    => $actual,
            expected  => $expected,
            show_diff => $show_diff,
        }, undef);

        return $self->fail($err->message);
    }

    else {
        my $msg = Util->get_message($self, [@_]);
        return $self->pass($msg);
    }
}

sub fail {
    my ($class, $msg) = @_;

    my $tb = $class->builder;
    return $tb->ok(0, $msg);
}

sub pass {
    my ($class, $msg) = @_;

    my $tb = $class->builder;
    return $tb->ok(1, $msg);
}

sub _obj {
    my ($self, $val) = @_;

    if (@_ == 1) {
        return flag($self, 'object');
    }

    else {
        flag($self, 'object', $val);
    }
}

1;
__END__
