# NAME

Geo::Coder::GeocodeFarm - Geocode addresses with the GeocodeFarm API

# SYNOPSIS

use Geo::Coder::Navteq;

    my $geocoder = Geo::Coder::Navteq->new(
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

    $geocoder = Geo::Coder::Navteq->new(
        key    => '3d517dd448a5ce1c2874637145fed69903bc252a',
        url    => 'http://geocodefarm.com/geo.php',
        ua     => LWP::UserAgent->new,
        parser => XML::Simple->new,
    );

Creates a new geocoding object. All arguments are optional.

An API key can be obtained at [http://geocodefarm.com/geocoding-dashboard.php](http://geocodefarm.com/geocoding-dashboard.php)

## geocode

    $result = $geocoder->geocode(
        location => $location
    )

Returns location result as a nested list:

    {
        COORDINATES => {
             Longitude => '-93.3995747',
             Latitude => '45.2040287',
        },
        PROVIDER => {
            IMPORT => 'ALREADY STORED',
            PROVIDER => 'LOCAL FARM',
        },
        ADDRESS => {
            Address => '530 WEST MAIN ST ANOKA MN 55303',
            Accuracy => 'GOOD ACCURACY',
        },
    }

Method returns undefined value if the service failed to find coordinates.

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
