#!/usr/bin/perl

use lib 'lib', '../lib';

use Geo::Coder::GeocodeFarm;
use YAML::XS;

my %args = map { /^(.*?)=(.*)$/ and ($1 => $2) } @ARGV;

my $geocoder = Geo::Coder::GeocodeFarm->new(%args);

my $location = $geocoder->geocode(%args);
die $geocoder->{error}, "\n" unless $location;
print Dump $location;
