require_relative 'lib/http_sim'

# one = HttpSimulator.new('GET', '/hi', 'hello')
# one.send :run

class Foo < Sinatra::Base
  HttpSimulator.register_endpoint 'GET', '/hi', 'yasssss'

  include HttpSimulator
end

Foo.run!
