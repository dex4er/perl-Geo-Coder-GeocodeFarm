package Geo::Coder::GeocodeFarm;

=head1 NAME

Geo::Coder::GeocodeFarm - Geocode addresses with the GeocodeFarm API

=head1 SYNOPSIS

use Geo::Coder::GeocodeFarm;

  my $geocoder = Geo::Coder::GeocodeFarm->new(
      key => '3d517dd448a5ce1c2874637145fed69903bc252a'
  );
  my $result = $geocoder->geocode(
      location => '530 West Main St Anoka MN 55303'
  );
  printf "%f,%f",
      $result->{COORDINATES}{latitude},
      $result->{COORDINATES}{longitude};

=head1 DESCRIPTION

The Geo::Coder::GeocodeFarm module provides an interface to the geocoding
functionality of the GeocodeFarm API.

=for readme stop

=cut


use 5.006;
use strict;
use warnings;

our $VERSION = '0.0300';

use Carp qw(croak);
use Encode;
use LWP::UserAgent;
use URI;
use URI::Escape;
use JSON;

use constant DEBUG => !! $ENV{PERL_GEO_CODER_GEOCODEFARM_DEBUG};


=head1 METHODS

=head2 new

  $geocoder = Geo::Coder::GeocodeFarm->new(
      key    => '3d517dd448a5ce1c2874637145fed69903bc252a',
      url    => 'http://www.geocodefarm.com/api/',
      ua     => LWP::UserAgent->new,
      parser => JSON->new->utf8,
      raise_failure => 1,
  );

Creates a new geocoding object. C<key> argument is required.

An API key can be obtained at L<http://geocodefarm.com/dashboard/login/>

New account can be registered at L<http://geocodefarm.com/dashboard/register/free/>

=cut

sub new {
    my ($class, %args) = @_;

    croak "Attribute (key) is required" unless defined $args{key};

    my $self = bless +{
        ua     => $args{ua} || LWP::UserAgent->new(
            agent     => __PACKAGE__ . "/$VERSION",
            env_proxy => 1,
        ),
        url    => 'http://www.geocodefarm.com/api/',
        parser => $args{parser} || JSON->new->utf8,
        raise_failure => $args{raise_failure} || 1,
        %args,
    } => $class;

    return $self;
}


=head2 geocode

  $result = $geocoder->geocode(
      location => $location
  )

Forward geocoding takes a provided address or location and returns the
coordinate set for the requested location as a nested list:

  {
      ACCOUNT => {
          api_key => '3d517dd448a5ce1c2874637145fed69903bc252a',
          email => 'joe.sixpack@example.net',
          monthly_due => '25.00',
          name => 'Joe Sixpack',
          next_due => '20130901',
          remaining_queries => '24995',
          usage_limit => '25000',
          used_today => '5',
      },
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

Slash C</> is replaced with dash C<-> in location string.

Method throws an error (or returns failure as nested list if raise_failure
argument is false) if the service failed to find coordinates or wrong key was
used.

Methods throws an error if there was an other problem.

=cut

sub geocode {
    my ($self, %args) = @_;

    my $location = $args{location};
    $location =~ tr{/}{-};
    $location = uri_escape_utf8 $location;

    my $url = URI->new_abs(sprintf('forward/json/%s/%s', $self->{key}, $location), $self->{url});
    warn $url if DEBUG;

    my $res = $self->{ua}->get($url);
    croak $res->status_line unless $res->is_success;

    my $content = $res->decoded_content;
    warn $content if DEBUG;
    return unless $content;

    my $data = eval { $self->{parser}->decode($content) };
    croak $content if $@;

    croak "GeocodeFarm API returned status: ", $data->{geocoding_results}{STATUS}{status}
        if ($self->{raise_failure} and ($data->{geocoding_results}{STATUS}{status}||'') ne 'SUCCESS');

    return $data->{geocoding_results};
};


=head2 reverse_geocode

  $result = $geocoder->reverse_geocode(
      lat => $latitude,
      lng => $longtitude,
  )

or

  $result = $geocoder->reverse_geocode(
      latlng => "$latitude,$longtitude",
  )

Reverse geocoding takes a provided coordinate set and returns the address for
the requested coordinates as a nested list:

  {
      ACCOUNT => {
          api_key => '3d517dd448a5ce1c2874637145fed69903bc252a',
          email => 'joe.sixpack@example.net',
          monthly_due => '25.00',
          name => 'Joe Sixpack',
          next_due => '20130901',
          remaining_queries => '24994',
          usage_limit => '25000',
          used_today => '6',
      },
      ADDRESS => {
          address => '500-534 West Main Street, Anoka, MN 55303, USA',
          accuracy => 'GOOD ACCURACY',
      },
      COORDINATES => {
          latitude => '45.204031',
          longitude => '-93.399573',
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

Method throws an error (or returns failure as nested list if raise_failure
argument is false) if the service failed to find coordinates or wrong key was
used.

Method throws an error if there was an other problem.

=cut

sub reverse_geocode {
    my ($self, %args) = @_;

    my ($lat, $lng) = do {
        if (defined $args{latlng}) {
            my @latlng = split ',', $args{latlng};
            croak "Attribute (latlng) is invalid" unless @latlng == 2;
            @latlng;
        }
        elsif (defined $args{lat} and defined $args{lng}) {
            @args{qw(lat lng)};
        }
        else {
            croak "Attribute (latlng) or attributes (lat) and (lng) are required";
        }
    };

    my $url = URI->new_abs(sprintf('reverse/json/%s/%s/%s', $self->{key}, $lat, $lng), $self->{url});
    warn $url if DEBUG;

    my $res = $self->{ua}->get($url);
    croak $res->status_line unless $res->is_success;

    my $content = $res->decoded_content;
    warn $content if DEBUG;
    return unless $content;

    my $data = eval { $self->{parser}->decode($content) };
    croak $content if $@;

    croak "GeocodeFarm API returned status: ", $data->{geocoding_results}{STATUS}{status}
        if ($self->{raise_failure} and ($data->{geocoding_results}{STATUS}{status}||'') ne 'SUCCESS');

    return $data->{geocoding_results};
};


1;


=for readme continue

=head1 SEE ALSO

L<http://www.geocodefarm.com/>

=head1 BUGS

If you find the bug or want to implement new features, please report it at
L<https://github.com/dex4er/perl-Geo-Coder-GeocodeFarm/issues>

The code repository is available at
L<http://github.com/dex4er/perl-Geo-Coder-GeocodeFarm>

=head1 AUTHOR

Piotr Roszatycki <dexter@cpan.org>

=head1 LICENSE

Copyright (c) 2013 Piotr Roszatycki <dexter@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

See L<http://dev.perl.org/licenses/artistic.html>
