package Test::Chai::Util::Reflection;

use Exporter qw/import/;
our @EXPORT_OK = qw/
    add_property
    add_method
    add_chainable_method
/;

sub add_property {
    my ($pkg, $name, $code) = @_;

    no strict 'refs'; ## no critic
    *{"${pkg}::${name}"} = sub {
        my $result = $code->(@_);
        return defined $result ? $result : $_[0];
    };
}

sub add_method {
    my ($pkg, $name, $code) = @_;

    no strict 'refs'; ## no critic
    *{"${pkg}::${name}"} = sub {
        my $result = $code->(@_);
        return defined $result ? $result : $_[0];
    };
}

sub add_chainable_method {
    my ($pkg, $name, $code, $chaining_behavior) = @_;

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

        if (scalar @_ - 1 >= 1) {
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
