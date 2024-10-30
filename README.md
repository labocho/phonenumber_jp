# PhonenumberJp

Phonenumber hypenates Japanese phone number.
Based on http://www.soumu.go.jp/main_sosiki/joho_tsusin/top/tel_number/number_shitei.html

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'phonenumber_jp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phonenumber_jp

## Usage

    PhonenumberJp.hyphenate("0300000000") # "03-0000-0000"
    PhonenumberJp.hyphenate("0520000000") # "052-000-0000"
    PhonenumberJp.hyphenate("+81300000000") # "+81-3-0000-0000"

    PhonenumberJp.e164("080-1234-5678", delimiter: " ") # "+81 80 1234 5678"
    PhonenumberJp.local("+818012345678", delimiter: "") # "08012345678"

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/labocho/phonenumber.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
