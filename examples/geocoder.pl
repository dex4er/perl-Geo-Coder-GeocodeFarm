#!/usr/bin/perl

use lib 'lib', '../lib';

use Geo::Coder::GeocodeFarm;
use Encode;
use Data::Dumper;

my %args = map { /^(.*?)=(.*)$/ and ($1 => decode_utf8($2)) } @ARGV;

die "Usage: geocoder.pl key=3d517dd448a5ce1c2874637145fed69903bc252a location='530 West Main St Anoka MN 55303'\n"
    unless defined $args{key} and defined $args{location};

my $geocoder = Geo::Coder::GeocodeFarm->new(%args);

my $result = $geocoder->geocode(%args);
die "Failed To Find Coordinates.\n" unless $result;

print Dumper $result;
