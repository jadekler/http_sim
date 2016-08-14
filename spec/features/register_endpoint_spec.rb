require 'spec_helper'

describe '/<endpoint>' do
  before :each do
    @sim = HttpSimulator.start_sim(port: test_port)

    # @sim.reset_endpoints

    @sim.register_endpoint(method: 'GET', endpoint: '/foo', body: 'something')
    @sim.register_endpoint(method: 'POST', endpoint: '/bar', body: 'something else')

    # @sim.run_daemon!(port: test_port)
  end

  after :each do
    # @sim.stop_daemon!(port: test_port)
  end

  it 'sets up an endpoint for each registered endpoint' do
    resp = get '/foo'
    expect(resp.code).to eq 200

    resp = post '/bar', 'some inconsequential json'
    expect(resp.code).to eq 200
  end
end
