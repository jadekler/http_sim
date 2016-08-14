require 'sinatra/base'
require 'httparty'
require_relative './sim'

module HttpSimulator
  def self.start_sim(port: 4567)
    app_wrapper = Class.new(Sim)

    self.run_daemon(app: app_wrapper)

    app_wrapper.new.helpers
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
