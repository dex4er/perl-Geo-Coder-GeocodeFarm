#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use Test::More tests => 4;

use Test::Deep;
use Test::Exception;

use Geo::Coder::GeocodeFarm;

my $ua = My::Mock::LWP::UserAgent->new;

{
    my $geocode = new_ok 'Geo::Coder::GeocodeFarm' => [key => 'Your GeocodeFarm key', ua => $ua];

    can_ok $geocode, qw(geocode);

    my $result = $geocode->geocode(location => 'Myśliwiecka 3/5/7, Warszawa, Poland');

    isa_ok $result, 'HASH';

    is $ua->{url}, 'http://www.geocodefarm.com/api/forward/json/Your%20GeocodeFarm%20key/My%C5%9Bliwiecka%203-5-7%2C%20Warszawa%2C%20Poland', 'url matches';
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
            "status": "SUCCESS"
        }
    }
}
END
}
