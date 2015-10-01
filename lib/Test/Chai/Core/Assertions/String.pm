package Test::Chai::Core::Assertions::String;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_string/;

use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Util::Inspect qw/inspect/;

sub assert_string {
    my ($self, $str, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    ref($self)->new($obj, $msg)->is->a('Str');

    return $self->assert(
        index($obj, $str) > -1,
        'expected #{this} to contain ' . inspect($str),
        'expected #{this} to not contain ' . inspect($str)
    );
}

1;
