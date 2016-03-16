require_relative 'lib/http_sim'

HttpSimulator.register_endpoint 'GET', '/hi', 'yasssss'
HttpSimulator.register_endpoint 'GET', '/bye', 'byeeeee'
HttpSimulator.run!
