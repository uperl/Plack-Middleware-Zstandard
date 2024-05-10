use Test2::V0 -no_srand => 1;
use Plack::Builder;
use Test2::Tools::HTTP qw( :short psgi_app_guard );
use HTTP::Request::Common;
use Compress::Stream::Zstd::Decompressor;

subtest 'basic' => sub {

  my $content = 'Hello World';

  my $app = psgi_app_guard builder {
    enable 'Zstandard';
    sub { [200, [ 'Content-Type' => 'text/plain', 'Content-Length' => length($content) ], [ $content ]] };
  };

  req(
    GET('/', 'Accept-Encoding' => 'zstd'),
    res {
      code 200;
      content_type 'text/plain';
      header 'Content-Length' => DNE();
      header 'Content-Encoding' => 'zstd';
      header 'Vary', 'Accept-Encoding';
    },
  );

  is(
    decompress(),
    'Hello World',
    'content',
  );

};

sub decompress {
  note $_ for map { $_->as_string} (tx->req, tx->res->headers);
  note '';
  my $decompressor = Compress::Stream::Zstd::Decompressor->new;
  my $decoded_content = $decompressor->decompress(tx->res->content);
  note $decoded_content;
  return $decoded_content;
}

done_testing;
