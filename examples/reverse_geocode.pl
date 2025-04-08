#!/usr/bin/perl

use lib 'lib', '../lib';

use Geo::Coder::GeocodeFarm;
use Data::Dumper;

my %args = map { /^(.*?)=(.*)$/ and ($1 => $2) } @ARGV;

die "Usage: reverse_geocoder.pl key=YOUR-API-KEY latlng='45.2040305,-93.3995728'\n"
    unless defined $args{key} and (defined $args{latlng} or (defined $args{lat} and defined $args{lon}));

my $geocoder = Geo::Coder::GeocodeFarm->new(%args);

my $result = $geocoder->reverse_geocode(%args);
die "Failed To Find Coordinates.\n" unless $result;

print Dumper $result;
