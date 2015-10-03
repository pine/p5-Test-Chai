use strict;
use warnings FATAL => 'all';
use utf8;

use t::Util;
use Test::Chai::Util::ObjDisplay qw/obj_display/;

subtest basic => sub {
    is obj_display(sub {}), '[Code]';
    is obj_display([ 1..1000 ]), '[ Array(1000) ]';
    is obj_display({ values => [ 1..1000 ] }), '{ Hash (values) }';
    is obj_display({ key1 => [ 1..1000 ], key2 => 0 }), '{ Hash (key1, key2) }';
    is obj_display({ key1 => [ 1..1000 ], key2 => 0, key3 => 0 }), '{ Hash (key1, key2, ...) }';
};

done_testing;
