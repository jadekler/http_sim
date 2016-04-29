require 'sinatra/base'

require 'httparty'

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
  @@pid = false

  def self.read_file(path)
    lines = []
    File.open(path, 'r') do |f|
      f.each_line do |line|
        lines.push line
      end
    end
    lines.join
  end

  @@erb_files = {
    index: self.read_file('lib/index.html.erb'),
    request: self.read_file('lib/request.html.erb'),
    response: self.read_file('lib/response.html.erb')
  }
  @@endpoints = []

  def self.run!(port: 4567)
    check_if_port_in_use(port)

    Sinatra::Base.get '/' do
      ERB.new(@@erb_files[:index]).result binding
    end

    Class.new(Sinatra::Base) {
      set :port, port

      include HttpSimulator
    }.run!
  end

  def self.run_daemon!(port: 4567, max_wait_seconds: 5)
    check_if_port_in_use(port)

    Sinatra::Base.get '/' do
      ERB.new(@@erb_files[:index]).result binding
    end

    @@pid = Process.fork do
      Class.new(Sinatra::Base) {
        set :port, port

        include HttpSimulator
      }.run!
    end

    wait_for_start(port, max_wait_seconds)

    at_exit do
      Process.kill 'SIGKILL', @@pid
    end

    @@pid
  end

  def self.stop_daemon!
    Process.kill('SIGKILL', @@pid) if @@pid
  end

  def self.wait_for_start(port, max_wait_seconds)
    wait_count = 0
    while wait_count < max_wait_seconds * 4
      begin
        HTTParty.get("http://localhost:#{port}/")
        return
      rescue Errno::ECONNREFUSED
        wait_count += 1
        sleep 0.25
      end
    end

    raise "Simulators failed to start - timed out after #{max_wait_seconds} seconds!"
  end

  def self.check_if_port_in_use(port)
    begin
      HTTParty.get("http://localhost:#{port}/")
      raise "Port #{port} already in use"
    rescue Errno::ECONNREFUSED
      # ignored
    end
  end

  def self.reset_endpoints
    @@endpoints = []
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
      ERB.new(@@erb_files[:response]).result binding
    end

    Sinatra::Base.put "#{endpoint.path}/response" do
      endpoint.response = request.body.read
    end

    Sinatra::Base.delete "#{endpoint.path}/response" do
      endpoint.response = endpoint.default_response
    end

    Sinatra::Base.get "#{endpoint.path}/requests" do
      @endpoint = endpoint
      ERB.new(@@erb_files[:request]).result binding
    end

    Sinatra::Base.delete "#{endpoint.path}/requests" do
      endpoint.requests = []
    end
  end
end
