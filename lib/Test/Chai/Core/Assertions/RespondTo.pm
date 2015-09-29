package Test::Chai::Core::Assertions::RespondTo;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_respond_to/;

use Scalar::Util qw/blessed/;

use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Util::Inspect qw/inspect/;

sub assert_respond_to {
    my ($self, $method, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;


    my $obj     = flag($self, 'object');
    my $context =
        blessed $obj ? \&{ref($obj).'::'.$method} :
        defined $obj ? \&{$obj.'::'.$method}      : undef;

    return $self->assert(
        ref $context eq 'CODE' && defined &$context,
        'expected #{this} to respond to ' . inspect($method),
        'expected #{this} to not respond to ' . inspect($method)
    );
}


1;
