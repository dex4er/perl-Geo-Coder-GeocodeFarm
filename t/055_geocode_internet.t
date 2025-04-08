#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

BEGIN { plan skip_all => "GEOCODEFARM_API_KEY not set" if not $ENV{GEOCODEFARM_API_KEY}; }

plan tests => 4;

use Test::RequiresInternet ('api.geocode.farm' => 443);

use Geo::Coder::GeocodeFarm;

my $geocode = new_ok 'Geo::Coder::GeocodeFarm', [key => $ENV{GEOCODEFARM_API_KEY},];

can_ok $geocode, qw(geocode);

my $result = $geocode->geocode(location => '530 W Main St Anoka MN 55303 US');

isa_ok $result, 'HASH';

is $result->{address}{full_address}, '530 W Main St, Anoka, MN 55303', '$result full_address';
