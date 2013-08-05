# NAME

Geo::Coder::GeocodeFarm - Geocode addresses with the GeocodeFarm API

# SYNOPSIS

use Geo::Coder::GeocodeFarm;

    my $geocoder = Geo::Coder::GeocodeFarm->new(
        key => '3d517dd448a5ce1c2874637145fed69903bc252a'
    );
    my $location = $geocoder->geocode(
        location => '530 West Main St Anoka MN 55303'
    );

# DESCRIPTION

The Geo::Coder::GeocodeFarm module provides an interface to the geocoding
functionality of the GeocodeFarm API.

# METHODS

## new

    $geocoder = Geo::Coder::GeocodeFarm->new(
        key    => '3d517dd448a5ce1c2874637145fed69903bc252a',
        url    => 'http://www.geocodefarm.com/api/',
        ua     => LWP::UserAgent->new,
        parser => JSON->new->utf8,
    );

Creates a new geocoding object. All arguments are optional.

An API key can be obtained at [http://geocodefarm.com/dashboard/login/](http://geocodefarm.com/dashboard/login/)

New account can be registered at [http://geocodefarm.com/dashboard/register/free/](http://geocodefarm.com/dashboard/register/free/)

## geocode

    $result = $geocoder->geocode(
        location => $location
    )

Returns location result as a nested list:

    {
        ADDRESS => {
            accuracy => 'GOOD ACCURACY',
            address_provided => '530 WEST MAIN ST ANOKA MN 55303',
            address_returned => '530 WEST MAIN STREET, ANOKA, MN 55303, USA',
        },
        COORDINATES => {
            latitude => '45.2040305',
            longitude => '-93.3995728',
        },
        PROVIDER => {
            import => 'ALREADY STORED',
            provider => 'LOCAL FARM',
        },
        STATUS => {
            access => 'KEY_VALID, ACCESS_GRANTED',
            copyright_logo => 'http://www.geocodefarm.com/assets/img/logo.png',
            copyright_notice => 'Results Copyright (c) 2013 GeocodeFarm. All Rights Reserved. No unauthorized redistribution without written consent from GeocodeFarm's Owners and Operators.',
            status => 'SUCCESS',
        },
    }

Returns failed status if the service failed to find coordinates or wrong key was used:

    {
        STATUS => {
            access => 'KEY_VALID, ACCESS_GRANTED',
            copyright_logo => 'http://www.geocodefarm.com/assets/img/logo.png',
            copyright_notice => 'Results Copyright (c) 2013 GeocodeFarm. All Rights Reserved. No unauthorized redistribution without written consent from GeocodeFarm's Owners and Operators.',
            status => 'FAILED, NO_RESULTS',
        },
    }

Methods throws an error if there was an other problem.

# SEE ALSO

[http://www.geocodefarm.com/](http://www.geocodefarm.com/)

# BUGS

If you find the bug or want to implement new features, please report it at
[https://github.com/dex4er/perl-Geo-Coder-GeocodeFarm/issues](https://github.com/dex4er/perl-Geo-Coder-GeocodeFarm/issues)

The code repository is available at
[http://github.com/dex4er/perl-Geo-Coder-GeocodeFarm](http://github.com/dex4er/perl-Geo-Coder-GeocodeFarm)

# AUTHOR

Piotr Roszatycki <dexter@cpan.org>

# LICENSE

Copyright (c) 2013 Piotr Roszatycki <dexter@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

See [http://dev.perl.org/licenses/artistic.html](http://dev.perl.org/licenses/artistic.html)
