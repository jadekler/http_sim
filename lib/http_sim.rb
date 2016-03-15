require 'sinatra/base'

class Endpoint
  attr_reader :method, :path, :default_response

  @@supported_methods = ['GET', 'PUT', 'PATCH', 'POST', 'DELETE']

  def initialize(method, path, default_response)
    raise "Unsupported method #{method}" unless @@supported_methods.include? method

    @method = method
    @path = path
    @default_response = default_response
  end
end

module HttpSimulator
  @@endpoints = []

  def self.register_endpoint(method, path, default_response)
    @@endpoints.push(Endpoint.new(method, path, default_response))
  end

  @@endpoints.each do |endpoint|
    case endpoint.method
      when 'GET'
        Sinatra::Base.get endpoint.path do
          endpoint.default_response
        end
      when 'PUT'
        Sinatra::Base.put endpoint.path do
          endpoint.default_response
        end
      when 'PATCH'
        Sinatra::Base.patch endpoint.path do
          endpoint.default_response
        end
      when 'POST'
        Sinatra::Base.post endpoint.path do
          endpoint.default_response
        end
      when 'DELETE'
        Sinatra::Base.delete endpoint.path do
          endpoint.default_response
        end
    end

    Sinatra::Base.get "/#{endpoint.path}/response" do
      "this is #{endpoint.path} get response"
    end

    Sinatra::Base.put "/#{endpoint.path}/response" do

    end

    Sinatra::Base.delete "/#{endpoint.path}/response" do

    end

    Sinatra::Base.get "/#{endpoint.path}/requests" do

    end

    Sinatra::Base.delete "/#{endpoint.path}/requests" do

    end
  end
end
