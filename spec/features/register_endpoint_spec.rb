require 'spec_helper'

describe '/<endpoint>' do
  before :each do
    @sim = HttpSimulator.start_sim(port: test_port)

    @sim.register_endpoint(method: 'GET', endpoint: '/foo', body: 'something')
    @sim.register_endpoint(method: 'POST', endpoint: '/bar/gaz', body: 'something else')
  end

  after :each do
    # @sim.stop
  end

  it 'sets up an endpoint for each registered endpoint' do
    # resp = get '/foo'
    # expect(resp.code).to eq 200

    resp = post '/bar/gaz', 'some inconsequential json'
    expect(resp.code).to eq 200
  end
end
