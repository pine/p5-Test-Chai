package Test::Chai::Core::Assertions::An;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_an/;

use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Util::Type qw/is_type/;

sub assert_an {
    my ($self, $type, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;

    my $obj     = flag($self, 'object');
    my $article = $type =~ /^[aeiou]/i ? 'an ' : 'a ';

    return $self->assert(
        is_type($obj, $type),
        'expected #{this} to be ' . $article . $type,
        'expected #{this} not to be ' . $article . $type
    ) ? undef : 0;
}
