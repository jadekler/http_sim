require 'sinatra/base'

def read_file(path)
  lines = []
  File.open(path, 'r') do |f|
    f.each_line do |line|
      lines.push line
    end
  end
  lines.join
end

class Endpoint
  attr_reader :method, :path, :default_response, :response
  attr_accessor :requests

  @@supported_methods = ['GET', 'PUT', 'PATCH', 'POST', 'DELETE']

  def initialize(method, path, default_response)
    raise "Unsupported method #{method}" unless @@supported_methods.include? method

    @method = method
    @path = path
    @response = default_response
    @default_response = default_response
    @requests = []
  end

  def add_request(request)
    @requests.push request
  end
end

module HttpSimulator
  @@endpoints = []

  def self.run!
    Sinatra::Base.get '/' do
      ERB.new(read_file('lib/index.html.erb')).result binding
    end

    Class.new(Sinatra::Base) {
      include HttpSimulator
    }.run!
  end

  def self.register_endpoint(method, path, default_response)
    raise '/ is a reserved path' if path == '/'

    endpoint = Endpoint.new(method, path, default_response)
    @@endpoints.push endpoint

    case endpoint.method
      when 'GET'
        Sinatra::Base.get endpoint.path do
          endpoint.add_request request.body.read
          endpoint.default_response
        end
      when 'PUT'
        Sinatra::Base.put endpoint.path do
          endpoint.add_request request.body.read
          endpoint.default_response
        end
      when 'PATCH'
        Sinatra::Base.patch endpoint.path do
          endpoint.add_request request.body.read
          endpoint.default_response
        end
      when 'POST'
        Sinatra::Base.post endpoint.path do
          endpoint.add_request request.body.read
          endpoint.default_response
        end
      when 'DELETE'
        Sinatra::Base.delete endpoint.path do
          endpoint.add_request request.body.read
          endpoint.default_response
        end
    end

    Sinatra::Base.get "#{endpoint.path}/response" do
      ERB.new(read_file('lib/response.html.erb')).result binding
    end

    Sinatra::Base.put "#{endpoint.path}/response" do
      endpoint.response = request.body.read
    end

    Sinatra::Base.delete "#{endpoint.path}/response" do
      endpoint.response = endpoint.default_response
    end

    Sinatra::Base.get "#{endpoint.path}/requests" do
      ERB.new(read_file('lib/request.html.erb')).result binding
    end

    Sinatra::Base.delete "#{endpoint.path}/requests" do
      endpoint.requests = []
    end
  end
end
