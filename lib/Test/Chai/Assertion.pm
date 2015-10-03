package Test::Chai::Assertion;
use strict;
use warnings;
use utf8;

use parent qw/Test::Builder::Module/;

use Test::Chai::AssertionError;
use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Util::Assertion qw/
    test
    get_message
    get_actual
/;
use Test::Chai::Util::Reflection qw/
    add_method
    add_property
    add_chainable_method
/;

# alias
sub AssertionError () { 'Test::Chai::AssertionError' }

sub new {
    my ($class, $obj, $msg, $stack) = @_;

    my $self = {};
    bless $self => $class;

    # Util->flag($self, 'ssfi' FIXME
    flag($self, 'object',  $obj);
    flag($self, 'message', $msg);

    return $self;
}

sub assert {
    my $self = shift;
    my ($expr, $msg, $negateMsg, $expected, $_actual, $show_diff) = @_;

    my $ok = test($self, [@_]);
    $show_diff = 0 if defined $show_diff && $show_diff != 1;

    if (!$ok) {
        my $msg    = get_message($self, [@_]);
        my $actual = get_actual($self, [@_]);

        my $err = AssertionError->new($msg, {
            actual    => $actual,
            expected  => $expected,
            show_diff => $show_diff,
        }, undef);

        return $self->_fail($err->message);
    }

    else {
        my $msg = get_message($self, [@_]);
        return $self->_pass($msg);
    }
}

sub _fail {
    my ($class, $msg) = @_;

    my $tb = $class->builder;
    return $tb->ok(0, $msg);
}

sub _pass {
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
