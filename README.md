# http_sim - Easy HTTP Simulators

[![Build Status](https://travis-ci.org/jadekler/http_sim.svg?branch=master)](https://travis-ci.org/jadekler/http_sim)

Simulate your external HTTP integrations.

**Contributions and issues very welcome**.

## Standalone usage

1. Add `gem 'http_sim'` to your `Gemfile`
1. `bundle install`
1. Use this code somewhere:

    ```ruby
    require 'http_sim'
    
    HttpSimulator.register_endpoint 'GET', '/hi', '{"some_json": true}'
    HttpSimulator.register_endpoint 'POST', '/bye', '<html><body>some html</body></html>'
    HttpSimulator.run!(port:6565)
    ```
    
1. The endpoints `GET /hi` and `POST /bye` are now set up. Visit `http://localhost:6565/` to see an index of running simulators and their helpers.

## Test usage

1. Add `gem 'http_sim'` to your `Gemfile`
1. `bundle install`
1. `some_spec.rb`:

    ```ruby
    describe 'some spec' do
      before :each do
        HttpSimulator.reset_endpoints
        HttpSimulator.register_endpoint 'POST', '/some_simulated_endpoint', 'some_simulated_content'
        HttpSimulator.run_daemon!(port: 6565)
      end
    
      after :each do
        HttpSimulator.stop_daemon!
      end
    
      it 'does something that needs a simulator backing it' do
        # your test here
      end
    end
    ```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/scaffold/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
    1. Please **add a test**
1. Run tests with `bundle install && rspec`
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request
