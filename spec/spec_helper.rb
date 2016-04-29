require 'httparty'

require_relative '../lib/http_sim'

RSpec.configure do |c|
  c.order = :random
  c.default_formatter = 'doc'
end

def start_simulator
  @@pid = fork do
    HttpSimulator.run!(port: 6565)
  end

  # TODO: Make a 'wait' function
  sleep 1
end
