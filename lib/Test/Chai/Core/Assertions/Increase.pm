package Test::Chai::Core::Assertions::Increase;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/
    assert_increase
/;

use Test::Chai::Util;
use Test::Chai::Assertion;

sub Util      () { 'Test::Chai::Util'         }
sub Assertion () { 'Test::Chai::Assertion'    }
sub flag         { Util->flag(@_)             }

sub assert_increase {
    my ($self, $object, $prop, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $fn = flag($self, 'object');

    # Assertion->new->($obj, $msg)->to->have->property # FIXME
    Assertion->new($fn)->is->a('CodeRef');

    my $initial = $object->{$prop};
    $fn->();

    return $self->assert(
        $object->{$prop} - $initial > 0,
        'expected .' . $prop . ' to increase',
        'expected .' . $prop . ' to not increase'
    );
}

1;
