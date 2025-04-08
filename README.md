# Geo::Coder::GeocodeFarm

[![CI](https://github.com/dex4er/perl-Geo-Coder-GeocodeFarm/actions/workflows/ci.yaml/badge.svg)](https://github.com/dex4er/perl-Geo-Coder-GeocodeFarm/actions/workflows/ci.yaml)
[![Trunk Check](https://github.com/dex4er/perl-Geo-Coder-GeocodeFarm/actions/workflows/trunk.yaml/badge.svg)](https://github.com/dex4er/perl-Geo-Coder-GeocodeFarm/actions/workflows/trunk.yaml)
[![CPAN](https://img.shields.io/cpan/v/Geo-Coder-GeocodeFarm)](https://metacpan.org/dist/Geo-Coder-GeocodeFarm)

## NAME

Geo::Coder::GeocodeFarm - Geocode addresses with the GeocodeFarm API

## SYNOPSIS

    use Geo::Coder::GeocodeFarm;

    my $geocoder = Geo::Coder::GeocodeFarm->new(
        key => 'YOUR-API-KEY-HERE',
    );
    my $result = $geocoder->geocode(
        location => '530 W Main St Anoka MN 55303 US'
    );
    printf "%f,%f",
        $result->{RESULTS}{result}{coordinates}{lat},
        $result->{RESULTS}{result}{coordinates}{lon};

## DESCRIPTION

The `Geo::Coder::GeocodeFarm` module provides an interface to the geocoding
functionality of the GeocodeFarm API v4.

## METHODS

## new

    $geocoder = Geo::Coder::GeocodeFarm->new(
        key    => 'YOUR-API-KEY-HERE',
        ua     => HTTP::Tiny->new,
        parser => JSON->new->utf8,
        raise_failure => 1,
    );

Creates a new geocoding object with optional arguments.

An API key is REQUIRED and can be obtained at
[https://geocode.farm/store/api-services/](https://geocode.farm/store/api-services/)

`ua` argument is a [HTTP::Tiny](https://metacpan.org/pod/HTTP%3A%3ATiny) object by default and can be also set to
[LWP::UserAgent](https://metacpan.org/pod/LWP%3A%3AUserAgent) object.

New account can be registered at [https://geocode.farm/store/api-services/](https://geocode.farm/store/api-services/)

## geocode

    $result = $geocoder->geocode(
        location => $location
    )

Forward geocoding takes a provided address or location and returns the
coordinate set for the requested location as json object:

    {
        "LEGAL": {
            "notice": "This system is the property of Geocode.Farm and any information contained herein is Copyright (c) Geocode.Farm. Usage is subject to the Terms of Service.",
            "terms": "https:\/\/geocode.farm\/policies\/terms-of-service\/",
            "privacy": "https:\/\/geocode.farm\/policies\/privacy-policy\/"
        },
        "STATUS": {
            "key": "VALID",
            "request": "VALID",
            "status": "SUCCESS",
            "credit_used": "1"
        },
        "USER": {
            "key": "YOUR-API-KEY-HERE",
            "name": "Your Name",
            "email": "yourname@yourdomain.com",
            "usage_limit": "UNLIMITED",
            "used_today": "1",
            "remaining_limit": "UNLIMITED"
        },
        "RESULTS": {
            "request": {
                "addr": "30 N Gould St, Ste R, Sheridan, WY 82801 USA"
            },
            "result": {
                "coordinates": {
                    "lat": "44.7977733966548",
                    "lon": "-106.954917523499"
                },
                "address": {
                    "full_address": "30 N Gould St, Sheridan, WY 82801, United States",
                    "house_number": "30",
                    "street_name": "N Gould St",
                    "locality": "Sheridan",
                    "admin_2": "Sheridan County",
                    "admin_1": "WY",
                    "country": "United States",
                    "postal_code": "82801"
                },
                "accuracy": "EXACT_MATCH"
            }
        }
    }

Method throws an error (or returns failure as nested list if raise\_failure
argument is false) if the service failed to find coordinates or wrong key was
used.

Methods throws an error if there was an other problem.

## reverse\_geocode

    $result = $geocoder->reverse_geocode(
        lat      => $latitude,
        lon      => $longtitude
    )

or

    $result = $geocoder->reverse_geocode(
        latlng => "$latitude,$longtitude",
        # ... optional args
    )

Reverse geocoding takes a provided coordinate set and returns the address for
the requested coordinates as a nested list. Its format is the same as for
["geocode"](#geocode) method.

Method throws an error (or returns failure as nested list if raise\_failure
argument is false) if the service failed to find coordinates or wrong key was
used.

Method throws an error if there was an other problem.

## SEE ALSO

[https://geocode.farm/](https://geocode.farm/)

## BUGS

If you find the bug or want to implement new features, please report it at
[https://github.com/dex4er/perl-Geo-Coder-GeocodeFarm/issues](https://github.com/dex4er/perl-Geo-Coder-GeocodeFarm/issues)

The code repository is available at
[http://github.com/dex4er/perl-Geo-Coder-GeocodeFarm](http://github.com/dex4er/perl-Geo-Coder-GeocodeFarm)

## AUTHOR

Piotr Roszatycki <dexter@cpan.org>

## LICENSE

Copyright (c) 2013, 2015, 2025 Piotr Roszatycki <dexter@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

See [http://dev.perl.org/licenses/artistic.html](http://dev.perl.org/licenses/artistic.html)
