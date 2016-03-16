# Scaffold

Simulate your external HTTP integrations.

**Contributions and issues very welcome**.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_sim'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_sim

## Usage

```
require 'http_sim'

HttpSimulator.register_endpoint 'GET', '/hi', read_file('fixtures/some_page.html')
HttpSimulator.register_endpoint 'POST', '/bye', read_file('fixtures/some_response.json')
HttpSimulator.run!
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/scaffold/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
