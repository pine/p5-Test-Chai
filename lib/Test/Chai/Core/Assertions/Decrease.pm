package Test::Chai::Core::Assertions::Decrease;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_decrease/;

use Test::Chai::Util::Flag qw/flag/;

sub assert_decrease {
    my ($self, $object, $prop, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $fn = flag($self, 'object');

    ref($self)->new($object, $msg)->to->have->property($prop);
    ref($self)->new($fn)->is->a('CodeRef');

    my $initial = $object->{$prop};
    $fn->();

    return $self->assert(
        $object->{$prop} - $initial < 0,
        'expected .' . $prop . ' to decrease',
        'expected .' . $prop . ' to not decrease'
    );
}

1;
