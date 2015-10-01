package Test::Chai::Util::ObjDisplay;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/obj_display/;

use DDP;

sub obj_display {
    my ($class, $obj) = @_;
    return np($obj); # FIXME
}

1;
