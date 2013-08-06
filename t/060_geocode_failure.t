#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 9;

use Test::Deep;
use Test::Exception;

use Geo::Coder::GeocodeFarm;

my $ua = My::Mock::LWP::UserAgent->new;

{
    my $geocode = new_ok 'Geo::Coder::GeocodeFarm' => [key => 'Your GeocodeFarm key', ua => $ua];

    can_ok $geocode, qw(geocode);

    throws_ok {
        $geocode->geocode(location => '530 West Main St Anoka MN 55303');
    } qr/FAILED, ACCESS_DENIED/;

    is $ua->{url}, 'http://www.geocodefarm.com/api/forward/json/Your%20GeocodeFarm%20key/530%20West%20Main%20St%20Anoka%20MN%2055303', 'url matches';
}

{
    my $geocode = new_ok 'Geo::Coder::GeocodeFarm' => [key => 'Your GeocodeFarm key', ua => $ua, raise_failure => 0];

    can_ok $geocode, qw(geocode);

    my $result = $geocode->geocode(location => '530 West Main St Anoka MN 55303');

    isa_ok $result, 'HASH';

    cmp_deeply $result, {
        "STATUS" => {
            "copyright_notice" => "Results Copyright (c) 2013 GeocodeFarm. All Rights Reserved. No unauthorized redistribution without written consent from GeocodeFarm's Owners and Operators.",
            "copyright_logo" => "http://www.geocodefarm.com/assets/img/logo.png",
            "access" => "ACCESS DENIED. CHECK API KEY, USAGE ALLOWANCE, AND BILLING.",
            "status" => "FAILED, ACCESS_DENIED"
        },
    }, '$result matches deeply';

    is $ua->{url}, 'http://www.geocodefarm.com/api/forward/json/Your%20GeocodeFarm%20key/530%20West%20Main%20St%20Anoka%20MN%2055303', 'url matches';
}


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
            "access": "ACCESS DENIED. CHECK API KEY, USAGE ALLOWANCE, AND BILLING.",
            "status": "FAILED, ACCESS_DENIED"
        }
    }
}
END
}
