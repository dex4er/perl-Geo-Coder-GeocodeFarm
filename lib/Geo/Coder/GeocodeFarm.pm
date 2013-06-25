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
