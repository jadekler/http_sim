require 'httparty'

require_relative '../lib/http_sim'

RSpec.configure do |c|
  c.order = :random
  c.default_formatter = 'doc'
end

def test_port
  6565
end

def secondary_test_port
  6566
end

def get(path, port = test_port)
  HTTParty.get("http://localhost:#{port}#{path}")
end

def json_get(path, port = test_port)
  HTTParty.get("http://localhost:#{port}#{path}", :headers => {'Content-Type' => 'application/json'})
end

def post(path, body, port = test_port)
  HTTParty.post("http://localhost:#{port}#{path}", :body => body)
end

def put(path, body, port = test_port)
  HTTParty.put("http://localhost:#{port}#{path}", :body => body)
end

def delete(path, port = test_port)
  HTTParty.delete("http://localhost:#{port}#{path}")
end
