package Test::Chai::Core::Assertions::Member;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/assert_member/;

use List::MoreUtils qw/any all/;

use Test::Chai::Util::Flag qw/flag/;
use Test::Chai::Util::Equal qw/eql/;

sub assert_member {
    my ($self, $subset, $msg) = @_;

    flag($self, 'message', $msg) if defined $msg;
    my $obj = flag($self, 'object');

    ref($self)->new($obj)->to->be->an('ArrayRef');
    ref($self)->new($subset)->to->be->an('ArrayRef');

    my $cmp = flag($self, 'deep') ? sub { eql(@_) } : undef;

    if (flag($self, 'contains')) {
        return $self->assert(
            is_subset_of($subset, $obj, $cmp),
            'expected #{this} to be a superset of #{act}',
            'expected #{this} to not be a superset of #{act}',
            $obj,
            $subset
        );
    }

    return $self->assert(
        is_subset_of($obj, $subset, $cmp) && is_subset_of($subset, $obj, $cmp),
        'expected #{this} to have the same members as #{act}',
        'expected #{this} to not have the same members as #{act}',
        $obj,
        $subset
    );
}

sub is_subset_of {
    my ($subset, $superset, $cmp) = @_;

    return all {
        my $elem = $_;
        return $cmp ?
            any { $cmp->($elem, $_) } @$superset :
            grep { $_ eq $elem } @$superset;
    } @$subset;
}

1;
