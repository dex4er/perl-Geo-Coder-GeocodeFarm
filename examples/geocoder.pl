#!/usr/bin/perl

# Usage:
#   geocoder.pl key=3d517dd448a5ce1c2874637145fed69903bc252a location='530 West Main St Anoka MN 55303'

use lib 'lib', '../lib';

use Geo::Coder::GeocodeFarm;
use YAML::XS;

my %args = map { /^(.*?)=(.*)$/ and ($1 => $2) } @ARGV;

my $geocoder = Geo::Coder::GeocodeFarm->new(%args);

my $result = $geocoder->geocode(%args);
die "Failed To Find Coordinates.\n" unless $result;

print Dump $result;
