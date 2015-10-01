package Test::Chai::Core::Assertions::InstanceOf;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_instance_of/;

use Scalar::Util qw/blessed/;

use Test::Chai::Util::Flag qw/flag/;

sub assert_instance_of {
    my ($self, $type, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    return $self->assert(
        blessed($obj) && $obj->isa($type),
        'expected #{this} to be an instance of ' . $type,
        'expected #{this} to not be an instance of ' . $type
    );
}

1;
