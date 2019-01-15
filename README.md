# Pingity [![Build Status](https://travis-ci.com/StandardGiraffe/pingity-gem.svg?branch=master)](https://travis-ci.com/StandardGiraffe/pingity-gem)

Generates a [Pingity](https://pingity.com) report on a website or email address using the API.

## Installation

(Until accepted to rubygems.org...) Add these lines to your application's Gemfile:

```ruby
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

...

gem 'pingity', git: "https://github.com/StandardGiraffe/pingity-gem.git"
```

And then execute:

    $ bundle

### Connecting your API keys

You can generate Pingity keys at the developer dashboard, [here](https://pingity.com/dashboard).

Add the following lines to your `./.env` file (or otherwise inject them into your `ENV` you see fit):

```
PINGITY_ID=<Your Pingity ID here>
PINGITY_SECRET=<Your Pingity Secret here>

PINGITY_API_BASE=https://pingity.com
```

## Basic Usage

```ruby
website = Pingity::Report.new("example.com")
email = Pingity::Report.new("garbage.email@missing.whatever")

website.result   #=> { complete report hash }
email.result     #=> { complete report hash }

website.status   #=> "pass"
email.status     #=> "fail_critical"

website.passed?  #=> true
email.passed?    #=> false

website.failed?  #=> false
email.failed?    #=> true
```

### Advanced Usage and Edge Cases

#### Report Arguments

You can initialize new `Pingity::Report`s with greater specificity, though this is normally unnecessary (and totally pointless at the time of this writing).

`Pingity::Report.new` takes the following *optional* arguments:

| **Argument** | **Notes** |
|:---:|:---|
| `:public_key` | Specifies an arbitrary Pingity ID |
| `:secret_key` | Specifies an arbitrary Pingity Secret |
| `:url` | Specifies an arbitrary API endpoint |
| `:eager` | if `true`, the report will be run on initialization (default is lazy).

So, for example:

```ruby
baz = Pingity::Report.new(
  "example.com",
  public_key: "blahblah",
  secret_key: "flahflah",
  url: "/supersecretapi/",
  eager: true
)
```

#### Operating the gem while developing Pingity

If developing Pingity itself, you may still wish to rely on the Pingity gem.  To make API calls to your local machine rather than the website, switch the `PINGITY_API_BASE` variable from `https://pingity.com/` to your localhost in the `.env` file:
```
PINGITY_API_BASE=localhost:3000
```

<!-- ## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/StandardGiraffe/pingity. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
 -->
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
