# PhonenumberJp

Hyphenate phonenumber in Japan.
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

    require "phonenumber_jp"
    PhonenumberJp.hyphenate("0312345678")  #=> "03-1234-5678"
    PhonenumberJp.hyphenate("0591234567")  #=> "059-1234-567"
    PhonenumberJp.hyphenate("08012345678") #=> "080-1234-5678"
    PhonenumberJp.hyphenate("0120123456")  #=> "0120-123-456"

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/phonenumber_jp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

