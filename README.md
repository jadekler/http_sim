# http_sim - Easy HTTP Simulators

Simulate your external HTTP integrations.

**Contributions and issues very welcome**.

## Usage

1. Add `gem 'http_sim'` to your `Gemfile`
1. `bundle install`
1. 
```ruby
require 'http_sim'

HttpSimulator.register_endpoint 'GET', '/hi', read_file('fixtures/some_page.html')
HttpSimulator.register_endpoint 'POST', '/bye', read_file('fixtures/some_response.json')
HttpSimulator.run!
```

The endpoints `GET /hi` and `POST /bye` are not set up. Visit `/` to see an index of running simulators and their helpers.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/scaffold/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
    1. Please **add a test**
1. Run tests with `bundle install && rspec`
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
