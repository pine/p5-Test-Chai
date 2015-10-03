package Test::Chai::Util::Assertion;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/
    test
    get_message
    get_actual
/;

use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Util::ObjDisplay qw/obj_display/;

sub test {
    my ($obj, $args) = @_;

    my $negate = flag($obj, 'negate');
    my $expr   = $args->[0];

    return defined $negate && $negate ? !$expr : $expr;
}

sub get_message {
    my ($obj, $args) = @_;

    my $negate   = flag($obj, 'negate');
    my $val      = flag($obj, 'object');
    my $expected = $args->[3];
    my $actual   = get_actual($obj, $args);
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
    my ($obj, $args) = @_;
    return @$args > 4 ? $args->[4] : $obj->_obj;
}

1;
