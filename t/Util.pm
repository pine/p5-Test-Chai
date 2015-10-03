use strict;
use warnings FATAL => 'all';
use utf8;

use Exporter qw/import/;

use File::Basename qw/dirname/;
use lib (
    dirname(__FILE__).'/../lib',
    dirname(__FILE__).'/lib',
);

use Test::More;
use Test::Deep;
use Test::Deep::Matcher;
use Test::Exception;
use Test::Mock::Guard;

our @EXPORT = (
    @Test::More::EXPORT,
    @Test::Deep::EXPORT,
    @Test::Deep::Matcher::EXPORT,
    @Test::Exception::EXPORT,
    @Test::Mock::Guard::EXPORT,
);

1;
