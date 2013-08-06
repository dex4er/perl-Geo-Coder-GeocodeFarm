#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;

use Test::Deep;

use Geo::Coder::GeocodeFarm;

my $ua = My::Mock::LWP::UserAgent->new;
my $geocode = new_ok 'Geo::Coder::GeocodeFarm' => [key => 'Your GeocodeFarm key', ua => $ua];

can_ok $geocode, qw(geocode);

my $result = $geocode->reverse_geocode(latlng => '45.2040305,-93.3995728');

isa_ok $result, 'HASH';

cmp_deeply $result, {
        "STATUS" => {
            "copyright_notice" => "Results Copyright (c) 2013 GeocodeFarm. All Rights Reserved. No unauthorized redistribution without written consent from GeocodeFarm's Owners and Operators.",
            "copyright_logo" => "http://www.geocodefarm.com/assets/img/logo.png",
            "access" => "KEY_VALID, ACCESS_GRANTED",
            "status" => "SUCCESS"
        },
        "PROVIDER" => {
            "provider" => "LOCAL FARM",
            "import" => "ALREADY STORED"
        },
        "ADDRESS" => {
            "address" => "500-534 West Main Street, Anoka, MN 55303, USA",
            "accuracy" => "GOOD ACCURACY"
        },
        "COORDINATES" => {
            "latitude" => "45.204031",
            "longitude" => "-93.399573"
        }
}, '$result matches deeply';

is $ua->{url}, 'http://www.geocodefarm.com/api/reverse/json/Your%20GeocodeFarm%20key/45.204031/-93.399573', 'url matches';


package My::Mock;

sub new {
    my ($class) = @_;
    return bless +{} => $class;
}


package My::Mock::LWP::UserAgent;

use base 'My::Mock';

sub get {
    my ($self, $url) = @_;
    $self->{url} = $url;
    return My::Mock::HTTP::Response->new;
}


package My::Mock::HTTP::Response;

use base 'My::Mock';

sub is_success {
    return 1;
}

sub decoded_content {
    return << 'END';
{
    "geocoding_results": {
        "STATUS": {
            "copyright_notice": "Results Copyright (c) 2013 GeocodeFarm. All Rights Reserved. No unauthorized redistribution without written consent from GeocodeFarm's Owners and Operators.",
            "copyright_logo": "http:\/\/www.geocodefarm.com\/assets\/img\/logo.png",
            "access": "KEY_VALID, ACCESS_GRANTED",
            "status": "SUCCESS"
        },
        "PROVIDER": {
            "provider": "LOCAL FARM",
            "import": "ALREADY STORED"
        },
        "ADDRESS": {
            "address": "500-534 West Main Street, Anoka, MN 55303, USA",
            "accuracy": "GOOD ACCURACY"
        },
        "COORDINATES": {
            "latitude": "45.204031",
            "longitude": "-93.399573"
        }
    }
}
END
}
