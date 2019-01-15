# Pingity

Generates a [Pingity](https://pingity.com) report on a website or email address using the API.

*Note:  Until deployment, the following instructions assume you're running the Pingity app locally, so all links point to `http://localhost:3000/...` rather than `https://www.pingity.com`.  Links will be updated when we go live.* 

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

You can generate Pingity keys at the developer dashboard, [here](http://localhost:3000/dashboard).

Add the following lines to your `./.env` file (or otherwise inject them into your `ENV` you see fit):

```
PINGITY_ID=<Your Pingity ID here>
PINGITY_SECRET=<Your Pingity Secret here>
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

You can initialize new `Pingity::Report`s with greater specificity, though this is normally unnecessary (and totally pointless at the time of this writing).

`Pingity::Report.new` takes the following *optional* arguments:

| **Argument** | **Notes** |
|:---:|:---|
| `:public_key` | Specifies an arbitrary Pingity ID |
| `:secret_key` | Specifies an arbitrary Pingity Secret |
| `:url` | Specifies an arbitrary API endpoint |

So, for example:

```ruby
baz = Pingity.Report.new(
  "example.com",
  public_key: "blahblah",
  secret_key: "flahflah",
  url: "https://www.pingity.com/supersecretapi/"
)
```

<!-- ## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/StandardGiraffe/pingity. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
 -->
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
