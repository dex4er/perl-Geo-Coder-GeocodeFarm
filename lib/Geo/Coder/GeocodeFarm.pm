package Geo::Coder::GeocodeFarm;

=head1 NAME

Geo::Coder::GeocodeFarm - Geocode addresses with the GeocodeFarm API

=head1 SYNOPSIS

use Geo::Coder::Navteq;

  my $geocoder = Geo::Coder::Navteq->new(
      key => '3d517dd448a5ce1c2874637145fed69903bc252a'
  );
  my $location = $geocoder->geocode(
      location => '530 West Main St Anoka MN 55303'
  );

=head1 DESCRIPTION

The Geo::Coder::GeocodeFarm module provides an interface to the geocoding
functionality of the GeocodeFarm API.

=for readme stop

=cut


use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

use Smart::Comments;
use Carp qw(croak);
use Encode;
use LWP::UserAgent;
use URI;
use XML::Simple;


sub new {
    my ($class, %args) = @_;

    my $self = bless +{
        ua => $args{ua} || LWP::UserAgent->new(
            agent => __PACKAGE__ . "/$VERSION",
            env_proxy => 1,
        ),
        url => 'http://geocodefarm.com/geo.php',
        parser => $args{parser} || XML::Simple->new(
            NoAttr  => 1,
        ),
        %args,
    } => $class;

    return $self;
}


sub geocode {
    my ($self, %args) = @_;

    my $location = $args{location};
    if (Encode::is_utf8($location)) {
        $location = Encode::encode_utf8($location);
    };

    my $url = URI->new($args{url} || $self->{url});
    $url->query_form(
        key => $args{key} || $self->{key},
        addr => $args{location},
    );

warn $url;

    my $res = $self->{ua}->get($url);
    return unless $res->is_success;

    my $content = $res->decoded_content;
    return unless $content;

    my $data = eval { $self->{parser}->xml_in(\$content) };
    $self->{error} = $content;
    return $data;
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
