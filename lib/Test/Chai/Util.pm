package Test::Chai::Util;
use strict;
use warnings;
use utf8;

use Mouse::Util::TypeConstraints ();
use Test::Deep::NoTest;
use DDP;

sub test {
    my ($class, $obj, $args) = @_;

    my $negate = $class->flag($obj, 'negate');
    my $expr   = $args->[0];

    return defined $negate && $negate ? !$expr : $expr;
}

sub matcher {
    my ($class, $type) = @_;
    return $class->is_type($type);
}

sub is_type {
    my $class = shift;

    my $constraint = Mouse::Util::TypeConstraints::find_or_create_isa_type_constraint(@_);
    return sub { $constraint->check(@_) };
}

sub get_message {
    my ($class, $obj, $args) = @_;

    my $negate   = $class->flag($obj, 'negate');
    my $val      = $class->flag($obj, 'object');
    my $expected = $args->[3];
    my $actual   = $class->get_actual($obj, $args);
    my $msg      = defined $negate && $negate ? $args->[2] : $args->[1];
    my $flag_msg = $class->flag($obj, 'message');

    $msg = $msg->() if ref $msg eq 'CODE';
    $msg = defined $msg ? $msg : '';
    $msg =~ s/#{this}/@{[$class->obj_display($val)]}/g;
    $msg =~ s/#{act}/@{[$class->obj_display($actual)]}/g;
    $msg =~ s/#{exp}/@{[$class->obj_display($expected)]}/g;

    return defined $flag_msg ? $flag_msg . ': ' . $msg : $msg;
}

sub get_actual {
    my ($class, $obj, $args) = @_;
    return @$args > 4 ? $args->[4] : $obj->_obj;
}

sub obj_display {
    my ($class, $obj) = @_;
    return np($obj); # FIXME
}

sub flag {
    my ($class, $obj, $key, $value) = @_;

    my $flags = $obj->{__flags};
    $flags = $obj->{__flags} = {} unless defined $flags;

    if (scalar @_ - 1 == 3) {
        $flags->{$key} = $value;
        return undef;
    }

    else {
        return $flags->{$key};
    }
}

sub eql {
    my $class = shift;
    return eql_deeply(@_);
}

sub add_property {
    my ($class, $pkg, $name, $code) = @_;

    no strict 'refs'; ## no critic
    *{"${pkg}::${name}"} = sub {
        my $result = $code->(@_);
        return defined $result ? $result : $_[0];
    };
}

sub add_method {
    my ($class, $pkg, $name, $code) = @_;

    no strict 'refs'; ## no critic
    *{"${pkg}::${name}"} = sub {
        my $result = $code->(@_);
        return defined $result ? $result : $_[0];
    };
}

sub add_chainable_method {
    my ($class, $pkg, $name, $code, $chaining_behavior) = @_;

    unless (defined $chaining_behavior) {
        $chaining_behavior = sub { };
    }

    my $chainable_behavior = {
        method            => $code,
        chaining_behavior => $chaining_behavior,
    };

    no strict 'refs'; ## no critic
    unless (defined *{"%${pkg}::__methods"}) {
        *{"${pkg}::__methods"} = {};
    }

    *{"${pkg}::__methods"}->{$name} = $chainable_behavior;

    *{"${pkg}::${name}"} = sub {
        &{$chainable_behavior->{chaining_behavior}}(@_);

        if (scalar @_ - 1 == 1) {
            # my $old_ssfi = $class->flag($_[0], 'ssfi');
            #
            # if (defined $old_ssfi) { # FIXME
            #     $class->flag($_[0], 'ssfi', $assert);
            # }

            my $result = &{$chainable_behavior->{method}}(@_);
            return defined $result ? $result : $_[0];
        }

        return $_[0];
    };
}

1;
