package Test::Chai::Core::Assertions::Satisfy;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_satisfy/;

use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Util::ObjDisplay qw/obj_display/;

sub assert_satisfy {
    my ($self, $matcher, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj    = flag($self, 'object');
    my $negate = flag($self, 'negate');
    my $result = $matcher->($obj);

    return $self->assert(
        $result,
        'expected #{this} to satisfy ' . obj_display($matcher),
        'expected #{this} to not satisfy' . obj_display($matcher),
        $negate ? 0 : 1,
        $result
    );
}

1;
