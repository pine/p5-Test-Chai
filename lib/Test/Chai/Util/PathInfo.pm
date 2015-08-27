package Test::Chai::Util::PathInfo;
use strict;
use warnings;
use utf8;

use Exporter qw/import/;
our @EXPORT_OK = qw/get_path_info/;

sub get_path_info {
    my ($path, $obj) = @_;

    my $parsed = _parse_path($path);
    my $last   = $parsed->[@$parsed - 1];

    my $info = {
        parent => @$parsed > 1 ? _get_path_value($parsed, $obj, @$parsed - 1) : $obj,
        name   => $last->{p} // $last->{i},
        value  => _get_path_value($parsed, $obj),
    };

    return $info;
}

sub _parse_path {
    my $path = shift;

    my $str   = $path; $str =~ s/([^\\])\[/$1.[/g;
    my @parts = $str =~ /(\\\.|[^.]+)+/g;

    return [ map {
        my $value = $_;
        my $re    = qr/^\[(\d+)\]$/;
        my @m_arr = $value =~ $re;

        if (@m_arr > 0) {
            { i => $m_arr[0] };
        }

        else {
            $value =~ s/\\([.\[\]])/$1/g;
            { p => $value };
        }
    } @parts ];
}

sub _get_path_value {
    my ($parsed, $obj, $index) = @_;

    my $tmp = $obj;
    my $res;

    $index = defined $index ? $index : @$parsed;

    for (my ($i, $l) = (0, $index); $i < $l; $i++) {
        my $part = $parsed->[$i];

        if ($tmp) {
            if (ref $tmp eq 'ARRAY') {
                if (defined $part->{p}) {
                    $tmp = $tmp->[$part->{p}];
                }

                elsif (defined $part->{i}) {
                    $tmp = $tmp->[$part->{i}];
                }
            }

            else {
                if (defined $part->{p}) {
                    $tmp = $tmp->{$part->{p}};
                }

                elsif (defined $part->{i}) {
                    $tmp = $tmp->{$part->{i}};
                }
            }

            if ($i == $l - 1) {
                $res = $tmp;
            }
        }

        else {
            $res = undef;
        }
    }

    return $res;
}

1;
