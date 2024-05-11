# Plack::Middleware::Zstandard ![static](https://github.com/uperl/Plack-Middleware-Zstandard/workflows/static/badge.svg) ![linux](https://github.com/uperl/Plack-Middleware-Zstandard/workflows/linux/badge.svg)

Compress response body with Zstandard

# SYNOPSIS

```perl
use Plack::Builder;

my $app = sub {
  return [
    200,
    [ 'Content-Type' => 'text/plain' ],
    [ "Hello World!\n" ],
  ];
};

builder {
  enable 'Zstandard';
  $app;
};
```

# DESCRIPTION

This middleware encodes the body of the response using Zstandard, based on the `Accept-Encoding`
request header.

# CONFIGURATION

- level

    Compression level.  Should be an integer from 1 to 22.  If not provided, then the default will
    be chosen by [Compress::Stream::Zstd](https://metacpan.org/pod/Compress::Stream::Zstd).

- vary

    If set to true (the default), then the response will vary on `Content-Encoding`.  This is usually
    what you want, but if you have another middleware or application that is already vary'ing on that
    header, you may want to set this to false.

# SEE ALSO

- [Plack::Middleware::Deflater](https://metacpan.org/pod/Plack::Middleware::Deflater)
- [Compress::Stream::Zstd](https://metacpan.org/pod/Compress::Stream::Zstd)

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2024 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
