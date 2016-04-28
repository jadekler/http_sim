# http_sim - Easy HTTP Simulators

[![Build Status](https://travis-ci.org/jadekler/http_sim.svg?branch=master)](https://travis-ci.org/jadekler/http_sim)

Simulate your external HTTP integrations.

**Contributions and issues very welcome**.

## Usage

1. Add `gem 'http_sim'` to your `Gemfile`
1. `bundle install`
1. Use this code somewhere:

    ```ruby
    require 'http_sim'
    
    HttpSimulator.register_endpoint 'GET', '/hi', read_file('fixtures/some_page.html')
    HttpSimulator.register_endpoint 'POST', '/bye', read_file('fixtures/some_response.json')
    HttpSimulator.run!
    ```
    
1. The endpoints `GET /hi` and `POST /bye` are now set up. Visit `/` to see an index of running simulators and their helpers.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/scaffold/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
    1. Please **add a test**
1. Run tests with `bundle install && rspec`
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request
