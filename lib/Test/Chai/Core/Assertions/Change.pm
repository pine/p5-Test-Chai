package Test::Chai::Core::Assertions::Change;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_change/;

use Test::Chai::Util::Flag qw/flag/;

sub assert_change {
    my ($self, $object, $prop, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $fn = flag($self, 'object');

    ref($self)->new($object, $msg)->to->have->property($prop);
    ref($self)->new($fn)->is->a('CodeRef');

    my $initial = $object->{$prop};
    $fn->();

    return $self->assert(
        $initial ne $object->{$prop},
        'expected .' . $prop . ' to change',
        'expected .' . $prop . ' to not change'
    );
}

1;
