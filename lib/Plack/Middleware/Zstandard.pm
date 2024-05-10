use warnings;
use 5.020;
use experimental qw( postderef signatures );

package Plack::Middleware::Zstandard {

  # ABSTRACT: Compress response body with Zstandard

  use parent qw( Plack::Middleware );
  use Plack::Util ();
  use Ref::Util qw( is_plain_arrayref );
  use Compress::Stream::Zstd::Compressor ();

  sub prepare_app ($self) {
  }

  sub call ($self, $env) {

    my $res = $self->app->($env);

    $self->response_cb($res, sub ($res) {
      return undef if $env->{HTTP_CONTENT_RANGE};

      my $h = Plack::Util::headers($res->[1]);
      return undef if Plack::Util::status_with_no_entity_body($res->[0]);
      return undef if $h->exists('Cache-Control') && $h->get('Cache-Control') =~ /\bno-transform\b/;

      my @vary = split /\s*,\s*/, ($h->get('Vary') || '');
      push @vary, 'Accept-Encoding';
      $h->set('Vary' => join(",", @vary));

      # Do not clobber already existing encoding
      return if $h->exists('Content-Encoding') && $h->get('Content-Encoding') ne 'identity';

      return undef unless ($env->{HTTP_ACCEPT_ENCODING} // '') =~ /\bzstd\b/;

      $h->set('Content-Encoding' => 'zstd');
      $h->remove('Content-Length');

      my $compressor = Compress::Stream::Zstd::Compressor->new;

      if($res->[2] && is_plain_arrayref $res->[2]) {
        $res->[2] = [grep length, map { $compressor->compress($_) } grep defined, $res->[2]->@*];
        my $end = $compressor->end;
        push $res->[2]->@*, $end if length $end;
        return undef;
      } else {
        return sub ($chunk) {
          if(defined $chunk) {
            return $compressor->compress($chunk);
          } elsif(defined $compressor) {
            my $end = $compressor->end;
            undef $compressor;
            return $end;
          } else {
            return undef;
          }
        };
      }
    });
  }

}

1;

=head1 SYNOPSIS

# EXAMPLE: examples/app.psgi

=head1 DESCRIPTION

This middleware encodes the body of the response using Zstandard, based on the C<Accept-Encoding>
request header.

=cut
