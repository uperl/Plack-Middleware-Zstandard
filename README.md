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

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2024 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
