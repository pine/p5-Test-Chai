package Test::Chai::AssertionError;
use strict;
use warnings;
use utf8;

use Data::Structure::Util qw/unbless/;

use Test::Chai::Util::Inspect qw/inspect/;
use Test::Chai::Util::ObjDisplay qw/obj_display/;

sub exclude {
    my $excludes = [@_];

    my $exclude_props = sub {
        my ($res, $obj) = @_;

        for my $key (keys %$obj) {
            if (!grep { $_ eq $key } @$excludes) {
                $res->{$key} = $obj->{$key};
            }
        }
    };

    return sub {
        my $args = [@_];
        my $i    = 0;
        my $res  = {};

        for (my $i = 0; $i < @$args; $i++) {
            $exclude_props->($res, $args->[$i]);
        }

        return $res;
    };
}

sub new {
    my ($class, $message, $_props, $ssf) = @_;

    my $extend = exclude('name', 'message', 'stack', 'constructor', 'toJSON');
    my $props  = $extend->($_props // {});

    my $self = {
        message   => $message // 'Unspecified AssertionError',
        show_diff => 0,
    };

    for my $key (keys %$props) {
        $self->{$key} = $props->{$key};
    }

    bless $self => $class;
    return $self;
}

sub name { 'AssertionError' }

sub message {
    my $self = shift;

    my $extend = exclude('constructor', 'toJSON', 'stack');
    my $props  = $extend->({ name => $self->name }, unbless($self));

    return inspect($props);
}

1;
