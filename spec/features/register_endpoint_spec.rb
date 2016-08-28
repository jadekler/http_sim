require 'spec_helper'

describe '/<endpoint>' do
  before :each do
    @sim = HttpSimulator.start_sim(port: test_port)

    @sim.register_endpoint(method: 'GET', path: '/foo', body: 'something')
    @sim.register_endpoint(method: 'POST', path: '/bar/gaz', body: 'something else')
  end

  after :each do
    # @sim.stop
  end

  it 'sets up an endpoint for each registered endpoint' do
    resp = get '/foo'
    expect(resp.code).to eq 200
    expect(resp.body).to eq 'something'

    resp = post '/bar/gaz', 'some inconsequential json'
    expect(resp.code).to eq 200
    expect(resp.body).to eq 'something else'
  end
end
