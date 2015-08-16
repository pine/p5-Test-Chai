use strict;
use warnings;
use utf8;

use t::Util;
use Test::Chai qw/expect/;

use Data::Dumper;

subtest expect => sub {
    expect(10)->to->be->a('Int');
    expect('abc')->to->be->a('Str');
    expect(0)->to->not->be->ok;
    expect(1)->to->not->be->undef;
    expect('NaN')->to->be->NaN;
    expect([1,2,3])->to->include(3);
    expect([])->to->be->empty;
    expect('abc')->to->equal('abcc');
};

done_testing;

