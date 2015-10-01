package Test::Chai::Core::Assertions::Length;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_length assert_length_chain/;

use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Util::GenericLength qw/generic_length/;

sub assert_length {
    my ($self, $n, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');
    my $len = generic_length($obj);

    return $self->assert(
        $len == $n,
        'expected #{this} to have a length of #{exp} but got #{act}',
        'expected #{this} to not have a length of #{act}',
        $n,
        $len
    );
}

sub assert_length_chain {
    flag(shift, 'do_length', 1);
}

1;
