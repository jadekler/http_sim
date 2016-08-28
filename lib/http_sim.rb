require 'sinatra/base'
require 'httparty'
require_relative './sim'

module HttpSimulator
  def self.start_sim(port: 4567) # TODO: Use this port
    app_wrapper = Class.new(Sim) do
      endpoints []

      def register_endpoint(method: 'GET', path: '/default_endpoint', body: 'Default body')
        p '&'*80
        p self.class.endpoints
        p '&'*80

        self.class.endpoints.push({method: method, path: path, body: body})
      end

      get '/*' do
        p '*'*80
        p self.class.endpoints
        p '*'*80

        # if contains_endpoint('GET', request.path)
        #   'boom'
        # end
      end
    end

    self.run_daemon(app: app_wrapper)

    app_wrapper
  end

  private

  def self.run_daemon(app:, log_file: 'http_sim_log.log')
    @pid = Process.fork do
      $stdout.reopen(log_file, 'w')
      $stdout.sync = true
      $stderr.reopen($stdout)
      app.run!
    end

    # wait_for_start(port, max_wait_seconds)
    sleep 1

    at_exit do
      Process.kill 'SIGKILL', @pid
    end

    @pid
  end
end
