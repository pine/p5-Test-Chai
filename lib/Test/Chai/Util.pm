package Test::Chai::Util;
use strict;
use warnings;
use utf8;


use Test::Deep::NoTest qw/eq_deeply/;
use Scalar::Util qw/looks_like_number blessed/;
use List::MoreUtils qw/any/;
use DDP;

use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Util::PathInfo qw/get_path_info/;
use Test::Chai::Util::Property qw/has_property/;
use Test::Chai::Util::ObjDisplay qw/obj_display/;

sub test {
    my ($class, $obj, $args) = @_;

    my $negate = flag($obj, 'negate');
    my $expr   = $args->[0];

    return defined $negate && $negate ? !$expr : $expr;
}

sub get_message {
    my ($class, $obj, $args) = @_;

    my $negate   = flag($obj, 'negate');
    my $val      = flag($obj, 'object');
    my $expected = $args->[3];
    my $actual   = $class->get_actual($obj, $args);
    my $msg      = defined $negate && $negate ? $args->[2] : $args->[1];
    my $flag_msg = flag($obj, 'message');

    $msg = $msg->() if ref $msg eq 'CODE';
    $msg = defined $msg ? $msg : '';
    $msg =~ s/#{this}/@{[obj_display($val)]}/g;
    $msg =~ s/#{act}/@{[obj_display($actual)]}/g;
    $msg =~ s/#{exp}/@{[obj_display($expected)]}/g;

    return defined $flag_msg ? $flag_msg . ': ' . $msg : $msg;
}

sub get_actual {
    my ($class, $obj, $args) = @_;
    return @$args > 4 ? $args->[4] : $obj->_obj;
}

1;
