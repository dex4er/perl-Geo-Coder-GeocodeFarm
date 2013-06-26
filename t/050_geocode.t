#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 9;
use Geo::Coder::GeocodeFarm;

my $geocode = new_ok 'Geo::Coder::GeocodeFarm' => [key => 'Your GeocodeFarm key', ua => My::Mock::LWP::UserAgent->new];

can_ok $geocode, qw(geocode);

my $result = $geocode->geocode(location => '530 West Main St Anoka MN 55303');

isa_ok $result, 'HASH';

is $result->{ADDRESS}{Accuracy}, 'GOOD ACCURACY', '{ADDRESS}{Accuracy}';
is $result->{ADDRESS}{Address}, '530 WEST MAIN ST ANOKA MN 55303', '{ADDRESS}{Address}';
is $result->{COORDINATES}{Latitude}, '45.2040287', '{COORDINATES}{Latitude}';
is $result->{COORDINATES}{Longitude}, '-93.3995747', '{COORDINATES}{Longitude}';
is $result->{PROVIDER}{IMPORT}, 'ALREADY STORED', '{PROVIDER}{IMPORT}';
is $result->{PROVIDER}{PROVIDER}, 'LOCAL FARM', '{PROVIDER}{PROVIDER}';


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
    return qq{<?xml version="1.0"?>\n<xml><PROVIDER><PROVIDER>LOCAL FARM</PROVIDER><IMPORT>ALREADY STORED</IMPORT></PROVIDER><ADDRESS><Address>530 WEST MAIN ST ANOKA MN 55303</Address><Accuracy>GOOD ACCURACY</Accuracy></ADDRESS><COORDINATES><Latitude>45.2040287</Latitude><Longitude>-93.3995747</Longitude></COORDINATES></xml>};
}
