# `base32h.rb`

## What is it?

It's the third reference implementation of an encoder and decoder for
Base32H, a new(-ish) duotrigesimal (that is: base-32) number
representation, written as a gem for Ruby.

## How do I install it?

Run `gem install base32h`, or include it in your `Gemfile`, or
whatever you would normally do to install a gem.

## How do I hack it?

```bash
git clone --recursive https://github.com/base32h/base32h.rb.git
cd base32h.rb
rspec  # to run the test suite
```

## How do I use it?

```ruby
require 'base32h'

Base32H.encode 17854910
# => "H0WDY"

Base32H.encode_bin "\xE3\xA9H\x83\x8D\xF5\xD5\x96\xD9\xD9"
# => "WELLH0WDYPARDNER"

Base32H.decode '88pzd'
# => 8675309

Base32H.decode_bin('2060w2g6009').unpack('C*')
# => [0, 0, 0, 8, 6, 7, 5, 3, 0, 9]
```

## Am I allowed to use it?

Yep!  Just follow the terms of the ISC license (see `COPYING` in this repo).
