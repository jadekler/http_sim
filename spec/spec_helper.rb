require 'httparty'

require_relative '../lib/http_sim'

RSpec.configure do |c|
  c.order = :random
  c.default_formatter = 'doc'
end

def test_port
  6565
end

def get(path)
  HTTParty.get("http://localhost:#{test_port}#{path}")
end

def json_get(path)
  HTTParty.get("http://localhost:#{test_port}#{path}", :headers => {'Content-Type' => 'application/json'})
end

def post(path, body)
  HTTParty.post("http://localhost:#{test_port}#{path}", :body => body)
end

def put(path, body)
  HTTParty.put("http://localhost:#{test_port}#{path}", :body => body)
end

def delete(path)
  HTTParty.delete("http://localhost:#{test_port}#{path}")
end
