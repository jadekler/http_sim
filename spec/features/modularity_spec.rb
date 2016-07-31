require 'spec_helper'

describe 'modularity' do
  describe 'two endpoints separately constructed' do
    before :each do
      @sim1 = HttpSimulator::Server.new
      @sim2 = HttpSimulator::Server.new

      @sim1.reset_endpoints
      @sim2.reset_endpoints
    end

    describe 'with same endpoints' do
      before :each do
        [@sim1, @sim2].each do |sim|
          sim.reset_endpoints
          sim.register_endpoint 'GET', '/foo', 'something one'
        end

        @sim1.run_daemon!(port: test_port)
        @sim2.run_daemon!(port: secondary_test_port)
      end

      it 'sets each endpoint up separately with same endpoints' do
        resp = get '/foo', test_port
        expect(resp.code).to eq 200

        resp = get '/foo', secondary_test_port
        expect(resp.code).to eq 200
      end
    end

    describe 'with different endpoints' do
      before :each do
        @sim1.register_endpoint 'GET', '/foo', 'something one'
        @sim2.register_endpoint 'GET', '/bar', 'something two'

        @sim1.run_daemon!(port: test_port)
        @sim2.run_daemon!(port: secondary_test_port)
      end

      it 'sets each endpoint up separately with different endpoints' do
        resp = get '/foo', test_port
        expect(resp.code).to eq 200

        resp = get '/bar', test_port
        expect(resp.code).to eq 404

        resp = get '/foo', secondary_test_port
        expect(resp.code).to eq 404

        resp = get '/bar', secondary_test_port
        expect(resp.code).to eq 200
      end

    end

    after :each do
      @sim1.stop_daemon!(port: test_port)
      @sim2.stop_daemon!(port: secondary_test_port)
    end
  end

  describe 'starting and stopping simulators independently' do
    before :each do
      @sim1 = HttpSimulator::Server.new
      @sim2 = HttpSimulator::Server.new

      [@sim1, @sim2].each do |sim|
        sim.reset_endpoints
        sim.register_endpoint 'GET', '/foo', 'something one'
      end
    end

    after :each do
      @sim1.stop_daemon!(port: test_port)
      @sim2.stop_daemon!(port: secondary_test_port)
    end

    it 'stops simulators independent of each other' do
      @sim1.run_daemon!(port: test_port)
      resp = get '/foo', test_port
      expect(resp.code).to eq 200

      @sim2.run_daemon!(port: secondary_test_port)
      resp = get '/foo', secondary_test_port
      expect(resp.code).to eq 200

      @sim1.stop_daemon!(port: test_port)

      # Stopping sim1 doesnt stop sim2
      resp = get '/foo', secondary_test_port
      expect(resp.code).to eq 200
    end
  end
end
