require 'sinatra/base'
require 'httparty'
require_relative './sim'

module HttpSimulator
  def self.start_sim(endpoints)
    configuration = Sim.new([])
    rackapp endpoints
  end

  private

  def self.rackapp(endpoints)
    Class.new(Sim) do
    end
  end

  def self.run_daemon
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
end
