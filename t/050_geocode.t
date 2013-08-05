#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 4;

use Test::Deep;

use Geo::Coder::GeocodeFarm;

my $geocode = new_ok 'Geo::Coder::GeocodeFarm' => [key => 'Your GeocodeFarm key', ua => My::Mock::LWP::UserAgent->new];

can_ok $geocode, qw(geocode);

my $result = $geocode->geocode(location => '530 West Main St Anoka MN 55303');

isa_ok $result, 'HASH';

cmp_deeply($result, {
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
            "address_provided" => "530 W MAIN ST ANOKA MN 55303 US",
            "address_returned" => "530 WEST MAIN STREET, ANOKA, MN 55303, USA",
            "accuracy" => "GOOD ACCURACY"
        },
        "COORDINATES" => {
            "latitude" => "45.2040305",
            "longitude" => "-93.3995728"
        }
});


package My::Mock;

sub new {
    my ($class) = @_;
    return bless +{} => $class;
}


package My::Mock::LWP::UserAgent;

use base 'My::Mock';

sub get {
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
            "address_provided": "530 W MAIN ST ANOKA MN 55303 US",
            "address_returned": "530 WEST MAIN STREET, ANOKA, MN 55303, USA",
            "accuracy": "GOOD ACCURACY"
        },
        "COORDINATES": {
            "latitude": "45.2040305",
            "longitude": "-93.3995728"
        }
    }
}
END
}
