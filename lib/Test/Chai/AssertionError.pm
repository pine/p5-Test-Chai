package Test::Chai::AssertionError;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT = qw/AssertionError/;

my $CLASS = __PACKAGE__;
sub AssertionError {
    return $CLASS;
}

sub new {
    my ($class, $message, $_props, $ssf) = @_;

    # my $extend =

    my $self = {
        message  => $message // 'Unspecified AssertionError',
        showDiff => 0,
    };

    while (my ($key, $value) = each(%$_props)) {
        $self->{key} = $value;
    }

    # FIXME ssf

    bless $self => $class;
    return $self;
}

sub throw {
    my $self = shift;

    my $tb = Test::Builder->new;
    $tb->($self->{message});
    $tb->is_passing(0) unless $tb->in_todo;
}

1;
