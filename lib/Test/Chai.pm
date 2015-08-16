package Test::Chai;
use strict;
use warnings;
use utf8;
our $VERSION = "0.01";

use Exporter qw/import/;
our @EXPORT_OK = qw/expect/;

use Test::Chai::Util;
use Test::Chai::Assertion;
use Test::Chai::Core::Assertions;
use Test::Chai::Interface::Expect;

1;
__END__


=encoding utf-8

=head1 NAME

Test::Chai - BDD / TDD assertion framework for Perl that can be paired with any testing framework

=head1 SYNOPSIS

    use Test::More;
    use Test::Chai qw/expect/;

    subtest test => sub {
        expect('test')->to->equal('test'); # ok
        expect([ 1, 2, 3 ])->to->include(3); # ok
        expect('test')->not->to->be('Bool'); # ok
        expect('NaN')->to->be('Int'); # not ok
    };

    done_testing;

=head1 DESCRIPTION

Test::Chai is BDD / TDD assertion framework inspired by [Chai](http://chaijs.com/) written by JavaScript.

=head1 LICENSE

The MIT License (MIT)

Copyright (c) 2015 Pine Mizune

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=head1 AUTHOR

Pine Mizune E<lt>pine@cpan.org<gt>

=cut
