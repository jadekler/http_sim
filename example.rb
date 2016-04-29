# Run me with `ruby example.rb`

require_relative 'lib/http_sim'

HttpSimulator.register_endpoint 'GET', '/hi', 'yasssss'
HttpSimulator.register_endpoint 'POST', '/bye', 'byeeeee'
HttpSimulator.run!(port: 6565)
