package Test::Chai::Util::IsType;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/is_type/;

use Mouse::Util::TypeConstraints ();

sub is_type {
    my ($obj, $type) = @_;
    my $constraint = Mouse::Util::TypeConstraints::find_or_create_isa_type_constraint($type);
    return $constraint->check($obj);
}

1;
