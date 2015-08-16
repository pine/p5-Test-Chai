package Test::Chai::Assertion;
use strict;
use warnings;
use utf8;

use parent qw/Test::Builder::Module/;

use Test::Chai::AssertionError;

sub Util { 'Test::Chai::Util' }

my $CLASS = __PACKAGE__;

sub new {
    my ($class, $obj, $msg, $stack) = @_;

    my $self = {};
    bless $self => $class;

    # Util->flag($self, 'ssfi' FIXME
    Util->flag($self, 'object', $obj);
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
    my ($expr, $msg, $negateMsg, $expected, $_actual, $showDiff) = @_;

    my $ok = Util->test($self, [@_]);

    # FIXME: showDiff
    if (!$ok) {
        my $msg    = Util->get_message($self, [@_]);
        my $actual = Util->get_actual($self, [@_]);

        $self->fail($msg);

        # AssertionError->new($msg, {
        #     actual   => $actual,
        #     expected => $expected,
        #     # showDiff => $showDiff, # FIXME
        # }, undef)->throw; # FIXME
    }

    else {
        $self->pass;
    }
}

sub pass {
    my $class = shift;

    my $tb = $CLASS->builder;
    $tb->ok(1, @_);
}

sub fail {
    my $class = shift;

    my $tb = $CLASS->builder;
    $tb->ok(0, @_);
}

1;
__END__
