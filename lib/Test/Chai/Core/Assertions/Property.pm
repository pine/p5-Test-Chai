package Test::Chai::Core::Assertions::Property;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_property/;

use Test::Chai::Util;
use Test::Chai::Util::GetPathInfo qw/get_path_info/;
use Test::Chai::Util::HasProperty qw/has_property/;
sub Util () { 'Test::Chai::Util' }
sub flag    { Test::Chai::Util->flag(@_) }

sub assert_property {
    my ($self, $name, $val, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;

    my $is_deep      = !!flag($self, 'deep');
    my $descriptor   = $is_deep ? 'deep property ' : 'property ';
    my $negate       = flag($self, 'negate');
    my $obj          = flag($self, 'object');
    my $path_info    = $is_deep ? get_path_info($name, $obj) : undef;
    my $has_property = $is_deep ? $path_info->{exists} : has_property($name, $obj);
    my $value        = $is_deep ? $path_info->{value} : $obj->{$name};

    if ($negate && @_ - 1 > 1) {
        unless (defined $value) {
            $msg = defined $msg ? "$msg: " : '';
            # FIXME: throw
        }
    }

    else {
        $self->assert(
            $has_property,
            'expected #{this} to have a ' . $descriptor . $name, # FIXME
            'expected #{this} to not have ' . $descriptor . $name
        );
    }

    if (@_ - 1 > 1) {
        # FIXME: inspect
        $self->assert(
            $val eq $value,
            'expected #{this} to have a ' . $descriptor . $name . ' of #{exp}, but got #{act}',
            'expected #{this} to not have a ' . $descriptor . $name . ' of #{act}',
            $val,
            $value
        );
    }

    flag($self, 'object', $value);
}

1;
