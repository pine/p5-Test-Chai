package Test::Chai::Util::Inspect;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/inspect/;

use DDP;

# FIXME
sub inspect { np(@_) }

1;
