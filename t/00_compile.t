use strict;
use warnings FATAL => 'all';
use utf8;

use t::Util;
use Module::Find;

use_ok $_ for findallmod 'Test::Chai';

done_testing;
