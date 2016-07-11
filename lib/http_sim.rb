require 'sinatra/base'
require 'httparty'
require_relative './endpoint'

module HttpSimulator
  class Server
    @pid = false

    def initialize
      @erb_files = {
        index: read_file('lib/index.html.erb'),
        request: read_file('lib/request.html.erb'),
        response: read_file('lib/response.html.erb')
      }
      @endpoints = []
    end

    def run!(port: 4567)
      check_if_port_in_use(port)

      Sinatra::Base.get '/' do
        ERB.new(@erb_files[:index]).result binding
      end

      Class.new(Sinatra::Base) {
        set :port, port
        set :logging, false

        # include HttpSimulator
      }.run!
    end

    def run_daemon!(port: 4567, max_wait_seconds: 5, log_file: 'http_sim_log.log')
      @pid = Process.fork do
        $stdout.reopen(log_file, 'w')
        $stdout.sync = true
        $stderr.reopen($stdout)
        run!(port: port)
      end

      wait_for_start(port, max_wait_seconds)

      at_exit do
        Process.kill 'SIGKILL', @pid
      end

      @pid
    end

    def stop_daemon!(port: 4567, max_wait_seconds: 5)
      Process.kill('SIGKILL', @pid) if @pid
      wait_for_stop(port, max_wait_seconds)
    end

    def wait_for_start(port, max_wait_seconds)
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

    def wait_for_stop(port, max_wait_seconds)
      wait_count = 0
      while wait_count < max_wait_seconds * 4
        begin
          HTTParty.get("http://localhost:#{port}/")
          wait_count += 1
          sleep 0.25
        rescue Errno::ECONNREFUSED
          return
        end
      end

      raise "Simulators failed to stop - timed out after #{max_wait_seconds} seconds!"
    end

    # TODO: Should this just be 'reset'?
    def reset_endpoints
      @endpoints = []
    end

    def register_endpoint(method, path, default_response)
      raise '/ is a reserved path' if path == '/'

      endpoint = Endpoint.new(method, path, default_response)
      @endpoints.push endpoint

      case endpoint.method
        when 'GET'
          Sinatra::Base.get endpoint.path do
            endpoint.add_request request.body.read
            endpoint.response
          end
        when 'PUT'
          Sinatra::Base.put endpoint.path do
            endpoint.add_request request.body.read
            endpoint.response
          end
        when 'PATCH'
          Sinatra::Base.patch endpoint.path do
            endpoint.add_request request.body.read
            endpoint.response
          end
        when 'POST'
          Sinatra::Base.post endpoint.path do
            endpoint.add_request request.body.read
            endpoint.response
          end
        when 'DELETE'
          Sinatra::Base.delete endpoint.path do
            endpoint.add_request request.body.read
            endpoint.response
          end
      end

      Sinatra::Base.get "#{endpoint.path}/response" do
        if env.key?('CONTENT_TYPE') && env['CONTENT_TYPE'] && env['CONTENT_TYPE'].include?('json')
          endpoint.response
        else
          ERB.new(@erb_files[:response]).result binding
        end
      end

      Sinatra::Base.put "#{endpoint.path}/response" do
        new_response = request.body.read
        endpoint.response = new_response
      end

      Sinatra::Base.post "#{endpoint.path}/response" do
        new_response = request.body.read.sub 'response=', ''
        endpoint.response = new_response
        redirect "#{endpoint.path}/response"
      end

      Sinatra::Base.delete "#{endpoint.path}/response" do
        endpoint.response = endpoint.default_response
      end

      Sinatra::Base.get "#{endpoint.path}/requests" do
        if env.key?('CONTENT_TYPE') && env['CONTENT_TYPE'] && env['CONTENT_TYPE'].include?('json')
          endpoint.requests.to_json
        else
          ERB.new(@erb_files[:request]).result binding
        end
      end

      Sinatra::Base.delete "#{endpoint.path}/requests" do
        endpoint.requests = []
      end
    end

    private

    def read_file(path)
      lines = []
      File.open(path, 'r') do |f|
        f.each_line do |line|
          lines.push line
        end
      end
      lines.join
    end

    def check_if_port_in_use(port)
      begin
        HTTParty.get("http://localhost:#{port}/")
        raise "Port #{port} already in use"
      rescue Errno::ECONNREFUSED
        # ignored
      end
    end
  end
end
