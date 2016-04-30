require 'spec_helper'

describe '/<endpoint>' do
  before :each do
    HttpSimulator.reset_endpoints

    HttpSimulator.register_endpoint 'GET', '/foo', 'something'
    HttpSimulator.register_endpoint 'POST', '/bar', 'something else'

    HttpSimulator.run_daemon!(port: test_port)
  end

  after :each do
    HttpSimulator.stop_daemon!(port: test_port)
  end

  it 'sets up an endpoint for each registered endpoint' do
    resp = get '/foo'
    expect(resp.code).to eq 200

    resp = post '/bar', 'some inconsequential json'
    expect(resp.code).to eq 200
  end
end
